import 'package:chat_app/viewmodel/theme_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/main.dart' as app;

void main() {
  late final ThemeViewModel themeViewModel;
  setUp(() {
    themeViewModel = ThemeViewModel();
  });

  test("Test Theme", () {
    app.main();
    expect(themeViewModel.isDarkMode, false);
    themeViewModel.switchThemeMode();
    expect(themeViewModel.isDarkMode, true);
  });
}
