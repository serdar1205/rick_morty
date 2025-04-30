import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit()
      : super(
            ThemeState(themeMode: ThemeMode.light));

  void updateTheme(ThemeMode theme) =>
      emit(ThemeState(themeMode: theme));


  @override
  ThemeState fromJson(Map<String, dynamic> json) => ThemeState.fromJson(json);

  @override
  Map<String, dynamic> toJson(ThemeState state) => state.toJson();
}
