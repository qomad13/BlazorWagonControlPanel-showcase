# ADR 0004: Hybrid OCR pipeline for wagon number recognition

## Status
Accepted (implemented in the full system); replaced with a stub in this showcase.

## Context
Wagon numbers had to be recognised automatically from RTSP cameras in near real time. Wagons can be dirty or damaged and the numbers partly hidden. Full HD frames (1920x1080) had to be processed at an acceptable speed (about 1 second per frame).

## Decision
A hybrid pipeline of two OCR engines:
- **EasyOCR** to quickly detect the regions that hold numbers on a Full HD image
- **PaddleOCR** to accurately read the digits in the detected regions

### Pipeline
1. Take a Full HD snapshot from the RTSP camera through OpenCvSharp
2. EasyOCR analyses the whole image and finds bounding boxes of potential numbers
3. The region crops go to PaddleOCR
4. PaddleOCR reads the digits in each region
5. Results are validated (number format, length) and returned

### Why a hybrid
- **EasyOCR**: fast on Full HD and good at finding regions, but weaker at reading digits on damaged wagons
- **PaddleOCR**: reads digits well even on damaged surfaces, but slow on whole Full HD frames
- **Together**: EasyOCR acts as the "spotter" and PaddleOCR reads only those regions

## Consequences

Timings below are the author's own measurements, not a formal benchmark.

### Positive
- Good accuracy even on damaged or dirty wagons
- Acceptable speed (about 1 second per Full HD frame)
- Flexible: detection and recognition thresholds can be tuned

### Negative
- Two dependencies (EasyOCR and PaddleOCR)
- More memory (two engines loaded)
- Harder debugging (two processing stages)
- Replaced with a stub in this showcase to keep the demo simple

## Alternatives

### EasyOCR only
- Faster
- Less accurate on damaged wagons
- Frequent recognition errors

### PaddleOCR only
- Better accuracy
- Slower on Full HD (3-5 seconds)
- Misses the time requirement

### Commercial OCR products
- High accuracy and speed
- High cost
- Vendor dependency
- May require cloud infrastructure

## Implementation
The module was built separately and integrated through the `ICameraRecognitionService` interface. This showcase uses `CameraStubService`, which returns "0000000", to illustrate the architecture without OCR library dependencies.
