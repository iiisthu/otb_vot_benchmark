% Run this file to build the needed mex-files on windows

% Build merResize
%mex -lopencv_core -lopencv_imgproc -L./ -I./ mexResize.cpp MxArray.cpp
mex -largeArrayDims -lopencv_core -lopencv_imgproc -I/usr/local/include -L/usr/local/lib mexResize.cpp MxArray.cpp

% Build setnonzeros from the lightspeed matlab toolbox
mex -largeArrayDims setnonzeros.c

% Build gradientMex from Piotrs toolbox
mex gradientMex.cpp -I./

% Build mtimesx
mex -DDEFINEUNIX -largeArrayDims -lmwblas mtimesx.c