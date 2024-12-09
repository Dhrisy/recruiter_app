// event
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavBarEvent {}

class ChangeIndex extends NavBarEvent {
  final int currentIndex;

  ChangeIndex({required this.currentIndex});
}

// state
class NavBarState {
  int currentIndex = 0;

  NavBarState({required this.currentIndex});
  NavBarState copyWith({ int? index}) {
    return NavBarState(currentIndex: index ?? this.currentIndex);
  }
}



// bloc
class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarState(currentIndex: 0)) {
    on<ChangeIndex>((event, emit) {
      emit(state.copyWith(index: event.currentIndex)); // Emit the updated state.
    });
  }
}



