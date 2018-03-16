clc; clear;

% Import Manopt and initialize the SBD package
run('../init_sbd');
fprintf('\n\n');

%% I. SIMULATE DATA FOR SBD:
%  =========================

%% 1. Kernel settings - see kernel types below
kerneltype = 'simulated_STM';   
n = 1;               	% number of kernel slices
k = [31 31];           	% kernel size

%% 2. Activation map settings:
m = [128 128];          % image size for each slice / observation grid

%   Each pixel has probability theta of being a kernel location
theta = 1e-3;           % activation concentration
eta = 1e-3;             % additive noise variance

%% 3. Generate kernel
switch kerneltype
    case 'random'
    % Randomly generate n kernel slices
        A0 = randn([k n]);
    
    case 'simulated_STM'
    % Randomly choose n kernel slices from simulated LDoS data
        load('example_data/LDoS_sim.mat');
        sliceidx = randperm(size(LDoS_sim,3), n);
        
        A0 = NaN([k n]);
        for i = 1:n
            A0 = imresize(LDoS_sim(:,:,sliceidx), k);
        end
        
    otherwise
        error('Invalid kernel type specified.')
end

% Need to put each slice back onto the sphere
A0 = proj2oblique(A0);
A0 = gpuArray(A0);

%% 4. Simulate activation map and observation:
% Generate activation map
X0_good = false;
while ~X0_good
    X0 = double(rand(m) <= theta);      % activations are on / off
    X0_good = sum(X0(:) ~= 0) > 0;
end

X0 = gpuArray(X0);

Y = zeros([m n], 'gpuArray');
for i = 1:n                           	% observation
    Y(:,:,i) = convfft2(A0(:,:,i), X0);     
end
Y = Y + sqrt(eta)*randn([m n]);

%% II. Sparse Blind Deconvolution:
%  ===============================
%% 1. Settings - refer to documents on details for setting parameters.

% A function for showing updates as RTRM runs
dispfun = @( Y, A, X, k, kplus, idx ) showims(Y,A0,X0,A,X,k,kplus,idx);

% SBD settings
params.lambda1 = 1e-1;              % regularization parameter for Phase I

params.phase2 = true;               % whether to do Phase II (refinement)
params.kplus = ceil(0.5 * k);       % padding for sphere lifting
params.lambda2 = 5e-2;              % FINAL reg. param. value for Phase II
params.nrefine = 3;                 % number of refinements

% Want entries of X to be nonnegative: see SBD_main.m
params.signflip = 0.2;
params.xpos     = true;

%% 2. The fun part
[Aout, Xout, extras] = SBD( Y, k, params, dispfun );
