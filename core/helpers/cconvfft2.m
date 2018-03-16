function [ C ] = cconvfft2( A, B, varargin)
%CCONVFFT2	FFT implementation of 2D cyclic convolution
%   C = cconvfft(A, B)	convolves A and B using the larger size
%
%   C = cconvfft(A, B, N)   convolves A and B using size N
%
%   C = cconvfft(A, B, N, adj)  convolves A and B using size N, 
%   'adj == 'left'' leads cconvfft2 to convolve B with the adjoint kernel 
%   of A, and 'adj == 'right'' convolves A with the adjoint of B.
%
%   Both N and adj can be left empty.

    numvararg = numel(varargin);
    
    if numvararg > 2
        error('Too many input arguments.');
    end
    
    N = max(size(A), size(B));
    if numvararg >= 1 && ~isempty(varargin{1})
        N = varargin{1};
    end
    
    A_hat = fft2(A,N(1),N(2));
    B_hat = fft2(B,N(1),N(2));
    if numvararg >= 2 && ~isempty(varargin{2})
        switch varargin{2}
            case 'left'
                A_hat = conj(A_hat);
            case 'right'
                B_hat = conj(B_hat);
        end
    end
    
    C = ifft2( A_hat .* B_hat );
    %ReC = real(C(1:4))
    %ImC = imag(C(1:4))
    C = real(C);

end

