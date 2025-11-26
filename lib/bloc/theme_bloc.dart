import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:track/local_storage_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  
  ThemeBloc() : super(LocalStorageRepository.getTheme() == true ? ThemeLight() : ThemeDark()) {
    on<ToggleTheme>((event, emit) {
      if (state is ThemeLight) {
        LocalStorageRepository.setTheme(false);
        emit(ThemeDark());
      } else {
        LocalStorageRepository.setTheme(true);
        emit(ThemeLight());
      }
    });
  }
}