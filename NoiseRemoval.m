function [cleanimg] = NoiseRemoval(img)
% Noise removal using gaussian filtering.

nhood=[3 3];

classChanged = 0;
if ~isa(img, 'double')
    classChanged = 1;
    img = im2double(img);
end

% Estimate the local mean of f.
localMean = filter2(ones(nhood), img) / prod(nhood);

% Estimate of the local variance of f.
localVar = filter2(ones(nhood), img.^2) / prod(nhood) - localMean.^2;

noise = mean2(localVar);

noise=max(noise,0.0001);

% Computation is split up to minimize use of memory
% for temp arrays.
cleanimg = img - localMean;
img = localVar - noise;
img = max(img, 0);
localVar = max(localVar, noise);
cleanimg = cleanimg ./ localVar;
cleanimg = cleanimg .* img;
cleanimg = cleanimg + localMean;

if classChanged,
    cleanimg = im2uint8(cleanimg);
end
