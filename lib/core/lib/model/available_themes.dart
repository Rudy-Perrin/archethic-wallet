// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../model/setting_item.dart';
import '../ui/themes/theme_dark.dart';
import '../ui/themes/theme_light.dart';
import '../ui/themes/themes.dart';

enum ThemeOptions { dark, light }

/// Represent notification on/off setting
class ThemeSetting extends SettingSelectionItem {
  ThemeSetting(this.theme);

  ThemeOptions theme;

  @override
  String getDisplayName(BuildContext context) {
    switch (theme) {
      case ThemeOptions.light:
        return 'Light';
      case ThemeOptions.dark:
        return 'Dark';
      default:
        return 'Dark';
    }
  }

  BaseTheme getTheme() {
    switch (theme) {
      case ThemeOptions.light:
        return LightTheme();
      case ThemeOptions.dark:
        return DarkTheme();
      default:
        return DarkTheme();
    }
  }

  // For saving to shared prefs
  int getIndex() {
    return theme.index;
  }
}