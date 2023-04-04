import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  setUserProperties({required String userId}) async {
    _analytics.setUserId(id: userId);
  }

  logLogin({String method = "email"}) async {
    _analytics.logLogin(loginMethod: method);
  }

  logSignUp({String method = "email"}) async {
    _analytics.logSignUp(signUpMethod: method);
  }

  logEvent({required String eventName}) async {
    _analytics.logEvent(name: eventName);
  }
}
