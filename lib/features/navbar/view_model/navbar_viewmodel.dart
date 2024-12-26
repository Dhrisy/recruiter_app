// // event
// import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class NavBarEvent{

// }

// class ChangeIndex extends NavBarEvent {
//   final int currentIndex;

//   ChangeIndex({required this.currentIndex});
// }

// // state
// class NavBarState {
//   int currentIndex = 0;

//   NavBarState({required this.currentIndex});
//   NavBarState copyWith({ int? index}) {
//     return NavBarState(currentIndex: index ?? this.currentIndex);
//   }
// }

// // bloc
// class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
//   NavBarBloc() : super(NavBarState(currentIndex: 0)) {
//     on<ChangeIndex>((event, emit) {
//       emit(state.copyWith(index: event.currentIndex)); // Emit the updated state.
//     });
//   }
// }

// event
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavBarEvent {
  @override
  List<Object?> get props => [];
}

class NavBarOnTapEvent extends NavBarEvent {
  final int index;

  NavBarOnTapEvent({required this.index});

  List<Object?> get props => [index];
}

// state
abstract class NavBarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavBarInitial extends NavBarState {
  final int index;
  NavBarInitial({required this.index});

  @override
  List<Object?> get props => [index];
}


class OnTapSucces extends NavBarState {
  final int index;
  OnTapSucces({required this.index});

  @override
  List<Object?> get props => [index];
}

// bloc
class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarInitial(index: 0)) {
    on<NavBarOnTapEvent>((event, emit){
      emit(OnTapSucces(index: event.index));

    });
  }
}
