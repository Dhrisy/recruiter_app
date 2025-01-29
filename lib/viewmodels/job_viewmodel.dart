// event
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class JobsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobFetchEvent extends JobsEvent {

}

// state
class JobsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobInitial extends JobsState {}

class JobLoading extends JobsState {}

class JobFetchSuccess extends JobsState {
  final List<JobPostModel> jobs;

  JobFetchSuccess({required this.jobs});
  @override
  List<Object?> get props => [jobs];
}

class JobEmpty extends JobsState{}

class JobFetchFailure extends JobsState {
  final String error;
  JobFetchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// bloc
class JobBloc extends Bloc<JobFetchEvent, JobsState> {
  final JobPostRepository jobRepository;
  JobBloc(this.jobRepository) : super(JobInitial()) {
    on<JobFetchEvent>((event, emit) async {
      emit(JobLoading());
print("ttttttttttttttttttttttttttttttttttttttttt");
      try {
        final response = await JobPostRepository().fetchPostedJobs();
        if (response != null) {
          response.isEmpty ? emit(JobEmpty())
         : emit(JobFetchSuccess(jobs: response));
        } 
        else {
          emit(JobFetchFailure(error: "Failed to fetch jobs"));
        }
      } catch (e) {
        print("Unexpected error $e");

        emit(JobFetchFailure(error: e.toString()));
      }
    });
  }
}
