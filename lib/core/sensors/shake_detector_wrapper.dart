import 'package:businesstrack/app/myapp.dart';
import 'package:businesstrack/core/sensors/shake_detector_provider.dart';
import 'package:businesstrack/core/sensors/widgets/quick_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that listens to shake detection and shows quick action dialog
class ShakeDetectorWrapper extends ConsumerStatefulWidget {
  final Widget child;

  const ShakeDetectorWrapper({super.key, required this.child});

  @override
  ConsumerState<ShakeDetectorWrapper> createState() =>
      _ShakeDetectorWrapperState();
}

class _ShakeDetectorWrapperState extends ConsumerState<ShakeDetectorWrapper> {
  bool _isDialogShowing = false;
  DateTime? _lastDialogShowTime;

  @override
  Widget build(BuildContext context) {
    // Listen to shake detector state
    ref.listen<AsyncValue>(shakeDetectorStateProvider, (previous, next) {
      next.whenData((shakeState) {
        // Only show dialog if shake is detected and dialog is not already showing
        if (shakeState.isShaking && !_isDialogShowing) {
          final now = DateTime.now();

          // Prevent showing dialog too frequently (minimum 3 seconds between dialogs)
          if (_lastDialogShowTime == null ||
              now.difference(_lastDialogShowTime!) >
                  const Duration(seconds: 3)) {
            _lastDialogShowTime = now;
            _showQuickActionDialog();
          }
        }
      });
    });

    return widget.child;
  }

  void _showQuickActionDialog() {
    setState(() {
      _isDialogShowing = true;
    });

    // Wait for next frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final navigatorContext = MyApp.navigatorKey.currentContext;
      if (navigatorContext == null) return;

      // Show the quick action dialog
      showDialog(
        context: navigatorContext,
        barrierDismissible: true,
        builder: (context) => const QuickActionDialog(),
      ).then((_) {
        // Reset dialog showing flag when dialog is dismissed
        if (mounted) {
          setState(() {
            _isDialogShowing = false;
          });
        }
      });

      // Show a subtle feedback (optional)
      _showShakeFeedback(navigatorContext);
    });
  }

  void _showShakeFeedback(BuildContext navigatorContext) {
    // Optional: Add haptic feedback or sound here
    final messenger = ScaffoldMessenger.maybeOf(navigatorContext);
    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.vibration, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text('Shake detected! Opening quick actions...'),
            ],
          ),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
