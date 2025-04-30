part of 'theme_cubit.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
    };
  }

  factory ThemeState.fromJson(Map<String, dynamic> json) {
    return ThemeState(
      themeMode: ThemeMode.values[json['themeMode'] as int],
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    String? selectedTitle,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
