import 'package:flutter/widgets.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function()? onAppPaused;
  final Future<void> Function()? onAppResumed;

  LifecycleEventHandler({this.onAppPaused, this.onAppResumed});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        if (onAppPaused != null) onAppPaused!();
        break;
      case AppLifecycleState.resumed:
        if (onAppResumed != null) onAppResumed!();
        break;
      default:
        break;
    }
  }
}
