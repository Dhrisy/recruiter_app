// event
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recruiter_app/features/job_post/data/job_post_repository.dart';
import 'package:recruiter_app/features/job_post/model/job_post_model.dart';

class JobsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobFetchEvent extends JobsEvent {}

// job search event
class SearchJobsEvent extends JobsEvent {
  final String query;

  SearchJobsEvent({required this.query});

  @override
  List<Object?> get props => [query];
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

class JobEmpty extends JobsState {}

class JobFetchFailure extends JobsState {
  final String error;
  JobFetchFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

// search state
class JobSearchSuccess extends JobsState {
  final List<JobPostModel> filteredJobs;

  JobSearchSuccess({required this.filteredJobs});

  @override
  List<Object?> get props => [filteredJobs];
}

// bloc
class JobBloc extends Bloc<JobsEvent, JobsState> {
  final JobPostRepository jobRepository;
    List<JobPostModel> allJobs = [];
  JobBloc(this.jobRepository) : super(JobInitial()) {
    on<JobFetchEvent>((event, emit) async {
      emit(JobLoading());
      try {
        final response = await JobPostRepository().fetchPostedJobs();
        if (response != null) {
          response.isEmpty
              ? emit(JobEmpty())
              : emit(JobFetchSuccess(jobs: response));
        } else {
          emit(JobFetchFailure(error: "Failed to fetch jobs"));
        }
      } catch (e) {
        print("Unexpected error $e");

        emit(JobFetchFailure(error: e.toString()));
      }
    });

    on<SearchJobsEvent>((event, emit) async {
      emit(JobLoading());
      if (event.query.isEmpty) {
        emit(JobFetchSuccess(
            jobs: allJobs)); // Show all jobs if query is empty
      } else {
        final filteredJobs = allJobs
            .where((job) =>
                job.title.toString().toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(JobSearchSuccess(filteredJobs: filteredJobs));
      }
    });
  }
}
