% CINEMATIC_FOCUS_PULL  Simulates a camera "focus pull" on a still image.
%
%   Select a photo and the script plays 30 frames that go from heavily
%   blurred to perfectly sharp, using:
%     - a Gaussian blur whose sigma follows a cosine curve (ease-in/ease-out)
%     - a red/blue channel shift (chromatic aberration)
%     - random sensor noise
%   The blur, shift and noise all fade out as the image comes into focus.
%
%   Requires: MATLAB + Image Processing Toolbox
%   Course:   ECE465 - Digital Signal Processing

[filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png', 'Image Files'}, 'Select your photo');
if isequal(filename, 0)
    disp('No file selected. Exiting...');
    return;
end

img = imread(fullfile(pathname, filename));
if size(img, 3) == 4, img = img(:, :, 1:3); end          % drop alpha channel (PNG)
if size(img, 3) == 1, img = repmat(img, [1, 1, 3]); end  % grayscale -> RGB
if size(img, 2) > 600, img = imresize(img, [NaN, 600]); end
img = im2double(img);   % scale to [0,1] (works for uint8 and uint16 images)

figure('Name', 'Cinematic Focus Pull', 'Position', [100, 100, 600, 500], 'Color', 'k');

frames = 30;
t = linspace(0, pi, frames);
sigmas = 14 * ((cos(t) + 1) / 2) + 0.1;

for i = 1:frames
    sigma = sigmas(i);

    % Gaussian kernel truncated at 3*sigma (separable: 2D kernel = g * g')
    halfSize = ceil(3 * sigma);
    x = -halfSize:halfSize;
    g = exp(-x.^2 / (2 * sigma^2));
    g = g / sum(g);

    % Replicate border pixels so the image edges do not darken
    padded = padarray(img, [halfSize, halfSize], 'replicate');
    processedImg = zeros(size(img));
    for c = 1:3
        processedImg(:, :, c) = conv2(g, g, padded(:, :, c), 'valid');
    end

    % Chromatic aberration: red shifts left, blue shifts right (edges replicated)
    shiftAmount = round(sigma * 0.7);
    if shiftAmount > 0
        R = processedImg(:, :, 1);
        B = processedImg(:, :, 3);
        processedImg(:, :, 1) = [R(:, shiftAmount+1:end), repmat(R(:, end), 1, shiftAmount)];
        processedImg(:, :, 3) = [repmat(B(:, 1), 1, shiftAmount), B(:, 1:end-shiftAmount)];
    end

    noiseLevel = (sigma / 15) * 0.06;
    noiseMatrix = noiseLevel * randn(size(processedImg));
    finalFrame = processedImg + noiseMatrix;

    finalFrame = max(0, min(1, finalFrame));

    imshow(finalFrame);
    title('Searching for focus...', 'FontSize', 14, 'Color', [0.8 0.8 0.8]);
    drawnow;
    pause(0.05);
end

imshow(img);
title('Focus Locked.', 'FontSize', 16, 'Color', [0 1 0]);
disp('Cinematic animation complete!');
