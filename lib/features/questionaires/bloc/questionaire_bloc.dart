import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_event.dart';
import 'package:recruiter_app/features/questionaires/bloc/questionaire_state.dart';
import 'package:recruiter_app/features/questionaires/data/questionaire_repository.dart';
import 'package:recruiter_app/features/questionaires/model/questionaire_model.dart';

class QuestionaireBloc extends Bloc<Questionaireevent, QuestionaireState> {
  final QuestionaireRepository questionaireRepository;
  QuestionaireBloc(this.questionaireRepository) : super(QuestionaireLoading()) {
    print("eeeeeeeeeeeeeeeeeeeeeeeeeee");
    on<QuestionaireSubmitEvent>((event, emit) async {
      emit(QuestionaireLoading());
      print("wwwwwwwwwwwwwwwwwwww");
      try {
        print("dddddddddddddd");
        print("ooooooooooooo ${event.logo}");
        final result = await questionaireRepository.questionaireSubmission(
            questionaire: QuestionaireModel(
                logo: event.logo,
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
                landlineNumber: event.landline,
                contactPersonName: event.contactPersonName));

        if (result == "success") {
          emit(QuestionaireSuccess());
        } else if (result == "error") {
          emit(QuestionaireFailure(
              error: "Something went wrong. Couldn't submit the details"));
        }
      } catch (e) {
        print("hhhhh     $e");
        emit(QuestionaireFailure(error: e.toString()));
      }
    });
  }
}
