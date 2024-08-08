import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedVisibilityWidget extends StatefulWidget {
  final Widget child;
  final Widget beforeChild;

  const AnimatedVisibilityWidget(
      {super.key, required this.child, required this.beforeChild});

  @override
  State<AnimatedVisibilityWidget> createState() =>
      _AnimatedVisibilityWidgetState();
}

class _AnimatedVisibilityWidgetState extends State<AnimatedVisibilityWidget> {
  bool _hasBeenVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (!_hasBeenVisible && info.visibleFraction > 0) {
          setState(() {
            _hasBeenVisible = true;
          });
        }
        if (kDebugMode) {
          print('Widget ${widget.key} has become visible');
          print('Visible fraction: ${info.visibleFraction}'); // Debug print
        } // Debug print
      },
      child: _hasBeenVisible ? widget.child : widget.beforeChild,
    );
  }
}
