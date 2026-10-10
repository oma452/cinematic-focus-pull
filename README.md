# Cinematic Focus Pull (MATLAB)

A Digital Signal Processing project (ECE466) that turns a single still image into a
cinematic "focus pull" animation, going from heavily blurred to perfectly sharp.

## How it works

- **Gaussian blur:** the kernel is rebuilt for every frame, and sigma follows a cosine
  curve so the focus starts slowly, speeds up in the middle and eases into sharpness.
  The 2D Gaussian is separable, so it is applied as two 1D passes with `conv2`.
- **Chromatic aberration:** the red and blue channels are shifted horizontally in
  opposite directions, by an amount proportional to the blur.
- **Sensor noise:** random Gaussian noise whose strength scales with the blur.
- **Edge handling:** border pixels are replicated before filtering, so the edges do not darken.
- All effects fade out as sigma decreases, and the final frame shows "Focus Locked."

## Requirements

- MATLAB (or MATLAB Online)
- Image Processing Toolbox (`imresize`, `padarray`, `imshow`, `im2double`)

## Usage

1. Open `cinematic_focus_pull.m` in MATLAB.
2. Run it (press **Run**, or type `cinematic_focus_pull` in the Command Window).
3. Choose a `.jpg`, `.jpeg` or `.png` photo when the file dialog appears.
4. Watch the animation play.

## Parameters you can tweak

| Variable | Default | Meaning |
|---|---|---|
| `frames` | `30` | Number of animation frames |
| `14` in `sigmas` | `14` | Maximum blur strength |
| `0.7` in `shiftAmount` | `0.7` | Strength of the colour-channel shift |
| `0.06` in `noiseLevel` | `0.06` | Maximum noise level |
| `pause(0.05)` | `0.05` s | Delay between frames |

## Project Report

The full report (introduction, methodology, flowchart, source code and results) is available here: [DSP_Project_Report.pdf](DSP_Project_Report.pdf)

## Authors

Omar Mohamed (ID 231147)
Omar Mohamed (ID 231147)
