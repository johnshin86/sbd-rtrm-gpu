# SBD-RTRM: Sparse blind deconvolution using the Riemannian Trust-Region Method (RTRM)

**SBD-RTRM** is a MATLAB package for *sparse blind deconvolution* (SBD) using the *Riemannian Trust Region* method (RTRM). As sparse blind deconvolution is a nonconvex problem, using RTRM ensures that local minima will be found in the associated optimization objective.

Our package is motivated by studies in blind deconvolution as a nonconvex optimization problem, and by applications in Scanning Tunneling Microscopy.

For documentations, info and references see [docs/README.ipynb](./docs/README.ipynb).

## Updates
**2018-03-16**:
-Implemented backwards Compatibility with Xsolve_pdNCG. 
-Multiple slices now works correctly for Xsolve_FISTA.

**2018-02-19**:
- Removed `signflip` option
- Option `getbias` to estimate constant bias is added across `SBD.m`, `Asolve_Manopt.m` and `Xsolve_FISTA.m`. The pdNCG solver is now depreciated in terms of both `Xpos` and `getbias`.

**2018-01-31**:
- Option to solve for **X**>=0 `Xpos` is included.
- Xsolver changed from pdNCG to FISTA, and the sparsity surrogate is changed from pseudo-Huber to Huber function.

## Upcoming changes
- Adding a reweighting method to sharpen recovered activation maps
- Make `SBD.m` work for multiple slices of data
- Account for border effects# sbd-rtrm-gpu
# sbd-rtrm-gpu
# sbd-rtrm-gpu
