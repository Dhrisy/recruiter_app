// import 'package:flutter/material.dart';

// class JobpostProvider extends ChangeNotifier{

// }

// event
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class JobPostEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobPostFormEvent extends JobPostEvent {
  final JobPostModel job;

  JobPostFormEvent({required this.job});

  @override
  List<Object?> get props => [job];
}

// edit form event
class EditJobPostFormEvent extends JobPostEvent {
  final JobPostModel job;
  EditJobPostFormEvent({required this.job});

  @override
  List<Object?> get props => [job];
}

// state
class JobPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobPostLoading extends JobPostState {}

class JobSubmitInitial extends JobPostState {}

class JobSubmitSuccess extends JobPostState {}

class EditJobFormSubmitSuccess extends JobPostState {}

class JobSubmitFailure extends JobPostState {
  final String error;

  JobSubmitFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

// bloc
class JobPostBloc extends Bloc<JobPostEvent, JobPostState> {
  final JobPostRepository jobRepository;
  JobPostBloc(this.jobRepository) : super(JobSubmitInitial()) {
    on<JobPostFormEvent>((event, emit) async {
      emit(JobPostLoading());
      final result = await jobRepository.jobPostRepository(job: event.job);
      if (result == "success") {
        emit(JobSubmitSuccess());
      } else {
        emit(JobSubmitFailure(error: result.toString()));
      }
    });

    on<EditJobPostFormEvent>((event, emit) async {
      emit(JobPostLoading());
      try {
        final result =
            await jobRepository.editJobPostRepository(job: event.job);

        if (result == "success") {
          emit(EditJobFormSubmitSuccess());
          
          
        } else {
          emit(JobSubmitFailure(error: result.toString()));
        }
      } catch (e) {
        emit(JobSubmitFailure(error: e.toString()));
      }
    });
  }
}
