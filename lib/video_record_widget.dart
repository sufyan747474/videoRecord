// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class VideoRecordWidget extends StatefulWidget {
//   const VideoRecordWidget({super.key});

//   @override
//   State<VideoRecordWidget> createState() => _VideoRecordWidgetState();
// }

// class _VideoRecordWidgetState extends State<VideoRecordWidget> {
//   late List<CameraDescription> _cameras;
//   late CameraController _controller;
//   bool _isInitialized = false;
//   bool _isRecording = false;
//   double _dragPosition = 0.0;
//   double _maxDragDistance = 80.0; // Maximum distance to drag to the left

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _cameras = await availableCameras();
//       if (_cameras.isNotEmpty) {
//         _controller = CameraController(_cameras[0], ResolutionPreset.max);
//         await _controller.initialize();
//         if (!mounted) {
//           return;
//         }
//         setState(() {
//           _isInitialized = true;
//         });
//       }
//     } catch (e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     }
//   }

//   Future<void> _startVideoRecording() async {
//     if (_controller.value.isRecordingVideo) {
//       return;
//     }
//     try {
//       await _controller.startVideoRecording();
//       setState(() {
//         _isRecording = true;
//       });
//     } catch (e) {
//       // Handle errors here.
//     }
//   }

//   Future<void> _stopVideoRecording() async {
//     if (!_controller.value.isRecordingVideo) {
//       return;
//     }
//     try {
//       await _controller.stopVideoRecording();
//       setState(() {
//         _isRecording = false;
//       });
//     } catch (e) {
//       // Handle errors here.
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isInitialized
//           ? Stack(
//               children: [
//                 CameraPreview(_controller),
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.bottomCenter,
//                     child: GestureDetector(
//                       onHorizontalDragUpdate: (details) {
//                         setState(() {
//                           // Ensure the drag is only to the left and within the max distance
//                           _dragPosition = (_dragPosition + details.delta.dx)
//                               .clamp(-_maxDragDistance, 0.0);
//                         });
//                       },
//                       onHorizontalDragEnd: (details) {
//                         setState(() {
//                           // Start video recording if dragged enough to the left
//                           if (_dragPosition <= -_maxDragDistance &&
//                               !_isRecording) {
//                             _startVideoRecording();
//                           } else if (_isRecording) {
//                             _stopVideoRecording();
//                           }
//                           // Reset position after drag ends
//                           _dragPosition = 0.0;
//                         });
//                       },
//                       child: Stack(
//                         children: [
//                           Positioned(
//                             left: _dragPosition,
//                             right: 0,
//                             bottom: 20,
//                             child: Container(
//                               width: 80,
//                               height: 80,
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   _isRecording ? "Recording..." : "Drag me",
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

// void main() => runApp(MaterialApp(home: VideoRecordWidget()));

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoRecordWidget extends StatefulWidget {
  const VideoRecordWidget({super.key});

  @override
  State<VideoRecordWidget> createState() => _VideoRecordWidgetState();
}

class _VideoRecordWidgetState extends State<VideoRecordWidget> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isLockIconVisible = false;
  double _dragPosition = 0.0;
  double _maxDragDistance = 80.0; // Maximum distance to drag to the left

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _controller = CameraController(_cameras[0], ResolutionPreset.max);
        await _controller.initialize();
        if (!mounted) {
          return;
        }
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  Future<void> _startVideoRecording() async {
    if (_controller.value.isRecordingVideo) {
      return;
    }
    try {
      await _controller.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      // Handle errors here.
    }
  }

  Future<void> _stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return;
    }
    try {
      await _controller.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      // Handle errors here.
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isInitialized
          ? Stack(
              children: [
                CameraPreview(_controller),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onPanStart: (_) {
                        setState(() {
                          // Show the lock icon when the pan starts
                          _isLockIconVisible = true;
                          log('touch');
                        });
                      },
                      onPanEnd: (_) {
                        setState(() {
                          // Hide the lock icon when the pan ends
                          _isLockIconVisible = false;
                          log('un touch');
                        });
                      },
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          // Ensure the drag is only to the left and within the max distance
                          _dragPosition = (_dragPosition + details.delta.dx)
                              .clamp(-_maxDragDistance, 0.0);
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        setState(() {
                          // Start video recording if dragged enough to the left
                          if (_dragPosition <= -_maxDragDistance &&
                              !_isRecording) {
                            _startVideoRecording();
                          } else if (_isRecording) {
                            _stopVideoRecording();
                          }
                          // Reset position after drag ends
                          _dragPosition = 0.0;
                        });
                      },
                      child: Stack(
                        children: [
                          Positioned(
                            left: _dragPosition,
                            right: 0,
                            bottom: 20,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  _isRecording ? "Recording..." : "Drag me",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -_maxDragDistance -
                                40, // Position of the lock icon
                            bottom: 40,
                            right: 0, // Slightly above the red button
                            child: Icon(
                              Icons.lock,
                              size: 40,
                              color: Colors.red.withOpacity(_isLockIconVisible
                                  ? 1.0
                                  : 0.0), // Show when dragging
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

void main() => runApp(MaterialApp(home: VideoRecordWidget()));
