import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Event
abstract class AppThemeDataEvent {}

class ChangeTheme extends AppThemeDataEvent {
  final bool isDarkMode;
  ChangeTheme({required this.isDarkMode});
}

class ToggleTheme extends AppThemeDataEvent {}



// State
class AppThemeDataState {
  final bool isDarkMode;

  AppThemeDataState({required this.isDarkMode});

  AppThemeDataState copyWith({bool? isDarkMode}) {
    return AppThemeDataState(
      isDarkMode: isDarkMode ?? this.isDarkMode
    );
  }
}

// Bloc
class AppThemeDataBloc extends Bloc<AppThemeDataEvent, AppThemeDataState> {
  AppThemeDataBloc() : super(AppThemeDataState(isDarkMode: false)) {
    on<ChangeTheme>(_onChangeTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onChangeTheme(ChangeTheme event, Emitter<AppThemeDataState> emit) async {
    // Save theme preference to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', event.isDarkMode);

    // Emit new state
    emit(state.copyWith(isDarkMode: event.isDarkMode));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<AppThemeDataState> emit) async {
    // Toggle the current theme
    final newThemeMode = !state.isDarkMode;

    // Save theme preference to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newThemeMode);

    // Emit new state
    emit(state.copyWith(isDarkMode: newThemeMode));
  }
}