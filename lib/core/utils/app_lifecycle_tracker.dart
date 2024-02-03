import 'package:flutter/material.dart';

enum AppState {
  opened,
  resumed,
  paused,
  inactive,
  detached,
}

class AppLifecycleTracker extends StatefulWidget {
  final Widget child;
  final void Function(AppState state) didChangeAppState;

  const AppLifecycleTracker({
    super.key,
    required this.didChangeAppState,
    required this.child,
  });

  @override
  State<AppLifecycleTracker> createState() => _AppLifecycleTrackerState();
}

class _AppLifecycleTrackerState extends State<AppLifecycleTracker>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    widget.didChangeAppState(AppState.opened);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    AppState s;
    switch (state) {
      case AppLifecycleState.resumed:
        s = AppState.resumed;
        break;
      case AppLifecycleState.inactive:
        s = AppState.inactive;
        break;
      case AppLifecycleState.detached:
        s = AppState.detached;
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      default:
        s = AppState.paused;
        break;
    }
    widget.didChangeAppState(s);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
