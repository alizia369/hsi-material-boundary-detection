# data/

Nothing in this folder is tracked by git (see `.gitignore`).

Expected input: hyperspectral cubes as `.mat` files (a variable holding an
H×W×B cube, or a struct with field `ref`) or ENVI `.hdr`/`.dat` files.
`demoHSI.m` infers the band wavelengths from the number of bands.

The original scripts had absolute paths to the author's machines. These were
replaced with relative placeholders that start with `.\data\...`, so the
simplest set-up is to copy (or symlink) your data here, keeping the same
sub-folder names, and run scripts from the repository root. You can also just
edit the path variables at the top of each script.
