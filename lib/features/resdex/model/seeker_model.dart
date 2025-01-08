import 'package:recruiter_app/core/utils/custom_functions.dart';

class SeekerModel {
  final SeekerPersonalModel? personalData;
  final List<SeekerEmploymetModel>? employmentData;
  final List<SeekerQualificationModel>? qualificationData;

  SeekerModel({this.employmentData, this.personalData, this.qualificationData});

  factory SeekerModel.fromJson(Map<String, dynamic> json) {
    return SeekerModel(
      personalData: json["personal"] != null
          ? SeekerPersonalModel.fromJson(json["personal"])
          : null,
      employmentData: json["employment"] != null
          ? (json["employment"] as List<dynamic>)
              .map((e) => SeekerEmploymetModel.fromJson(e))
              .toList()
          : null,
      qualificationData: json["qualification"] != null
          ? (json["qualification"] as List<dynamic>)
              .map((q) => SeekerQualificationModel.fromJson(q))
              .toList()
          : null,
    );
  }
}

class SeekerPersonalModel {
  // final String? id;
  final User user;
  final String? introduction;
  final bool? employed;
  final String? city;
  final String? state;
  final String? nationality;
  final String? gender;
  final String? cv;
  final String? profileImage;
  final Map<String, dynamic>? skills;
  final Map<String, dynamic>? languages;
  final Map<String, dynamic>? certificates;
  final Map<String, dynamic>? projects;
  final String? preferedSalaryPackage;
  final Map<String, dynamic>? preferedWorkLocations;
  final String? totalExperienceYears;
  final String? totalExperienceMonths;

  SeekerPersonalModel({
    this.certificates,
    this.city,
    this.cv,
    this.employed,
    this.gender,
    required this.user,
    this.introduction,
    this.languages,
    this.nationality,
    this.preferedSalaryPackage,
    this.preferedWorkLocations,
    this.profileImage,
    this.projects,
    this.skills,
    this.state,
    this.totalExperienceMonths,
    this.totalExperienceYears,
  });

  factory SeekerPersonalModel.fromJson(Map<String, dynamic> json) {
    return SeekerPersonalModel(
        certificates: json["certificates"] ?? {},
        city: json["city"] ?? "N/A",
        cv: json["cv"],
        employed: json["emplyed"] ?? false,
        gender: json["gender"] ?? "N/A",
        user: User.fromJson(json["user"]),
        introduction: json["intro"] ?? "N/A",
        languages: json["languages"] ?? {},
        nationality: json["nationality"] ?? "N/A",
        preferedSalaryPackage: json["prefered_salary_pa"].toString(),
        preferedWorkLocations: json["prefered_work_loc"] ?? {},
        profileImage: CustomFunctions.validateUrl(json["profile_image"] ?? ""),
        projects: json["projects"] ?? {},
        skills: json["skills"] ?? {},
        state: json["state"] ?? "N/A",
        totalExperienceMonths: json["total_experience_years"].toString(),
        totalExperienceYears: json["total_experience_months"].toString());
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;

  User({this.email, this.id, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json["email"] ?? "N/A",
        id: json["id"].toString(),
        name: json["name"] ?? "N/A");
  }
}

class SeekerEmploymetModel {
  final String? id;
  final String? experience;
  final String? jobTitle;
  final String? companyName;
  final String? duration;
  final String? ctc;
  final String? noticePeriod;
  final String? department;
  final String? jobRole;
  final String? roleCategory;

  SeekerEmploymetModel({
    this.companyName,
    this.ctc,
    this.department,
    this.duration,
    this.id,
    this.experience,
    this.jobRole,
    this.jobTitle,
    this.noticePeriod,
    this.roleCategory,
  });

  factory SeekerEmploymetModel.fromJson(Map<String, dynamic> json) {
    return SeekerEmploymetModel(
      companyName: json["company_name"] ?? "N/A",
      ctc: json["ctc"].toString(),
      department: json["department"] ?? "N/A",
      duration: json["duration"].toString(),
      experience: json["experiance"].toString(),
      id: json["id"].toString(),
      jobRole: json["job_role"] ?? "N/A",
      jobTitle: json["job_title"] ?? "N/A",
      noticePeriod: json["notice_pd"].toString(),
      roleCategory: json["role_category"] ?? "N/A",
    );
  }
}

class SeekerQualificationModel {
  final String? id;
  final String? education;
  final String? course;
  final String? specialization;
  final String? university;
  final String? startingYr;
  final String? endingYr;
  final String? grade;
  final String? typeCourse;

  SeekerQualificationModel(
      {this.course,
      this.education,
      this.endingYr,
      this.grade,
      this.id,
      this.specialization,
      this.startingYr,
      this.university,
      this.typeCourse});

  factory SeekerQualificationModel.fromJson(Map<String, dynamic> json) {
    return SeekerQualificationModel(
        course: json["course"] ?? "N/A",
        education: json["education"] ?? "N/A",
        endingYr: json["ending_yr"].toString(),
        grade: json["grade"].toString(),
        id: json["id"].toString(),
        specialization: json["specialisation"] ?? "N/A",
        startingYr: json["starting_yr"].toString(),
        university: json["university"] ?? "N/A",
        typeCourse: json["type_course"].toString());
  }
}
