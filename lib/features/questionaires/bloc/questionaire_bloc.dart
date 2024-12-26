import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_event.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_state.dart';
import 'package:recruiter_app/features/questionaires/data/questionaire_repository.dart';
import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';

class QuestionaireBloc extends Bloc<Questionaireevent, QuestionaireState> {
  final QuestionaireRepository questionaireRepository;
  QuestionaireBloc(this.questionaireRepository) : super(QuestionaireLoading()) {
    on<QuestionaireSubmitEvent>((event, emit) async {
      emit(QuestionaireLoading());

      try {
        final result = await questionaireRepository.questionaireSubmission(
          questionaire: QuestionaireModel(
              about: event.aboutCompany,
              industry: event.industry,
              functionalArea: event.functionalArea,
              address: event.address,
              city: event.city,
              country: event.country,
              postalCode: event.postalCode,
              mobileNumber: event.mobilePhn,
              designation: event.designation,
              website: event.website,
              contactPersonName: event.contactPersonName));

      if (result == "success") {
        emit(QuestionaireSuccess());
      } else if (result == "error") {
        emit(QuestionaireFailure(
            error: "Something went wrong. Couldn't submit the details"));
      }
      } catch (e) {
        emit(QuestionaireFailure(error: e.toString()));
      }
    });
  }
}
