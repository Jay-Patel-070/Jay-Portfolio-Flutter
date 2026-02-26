import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final themeProvider = StateNotifierProvider<ThemeController, bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeController(prefs);
});

class ThemeController extends StateNotifier<bool> {
  static const _themeKey = 'isDarkMode';
  final SharedPreferences _prefs;

  ThemeController(this._prefs) : super(_prefs.getBool(_themeKey) ?? true);

  void toggleTheme() {
    state = !state;
    _prefs.setBool(_themeKey, state);
  }
}
