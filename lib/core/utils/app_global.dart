import 'package:chat_app/core/utils/app_lifecycle_tracker.dart';

/// singleton class which is accessible across the app and shares the same state
class AppGlobal {
  static final AppGlobal instance = AppGlobal._internal();
  AppGlobal._internal();

  AppState? _appState;
  // ignore: unnecessary_getters_setters
  AppState? get appState => _appState;
  set appState(AppState? state) => _appState = state;

  String? _deviceToken;
  // ignore: unnecessary_getters_setters
  String? get deviceToken => _deviceToken;
  set deviceToken(String? token) => _deviceToken = token;
}
