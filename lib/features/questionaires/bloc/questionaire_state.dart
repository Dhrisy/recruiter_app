import 'package:equatable/equatable.dart';

class QuestionaireState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionaireLoading extends QuestionaireState{}

class QuestionaireSuccess extends QuestionaireState{}

class QuestionaireFailure extends QuestionaireState{
  final String error;

  QuestionaireFailure({required this.error});
  List<Object?> get props => [error];
}
