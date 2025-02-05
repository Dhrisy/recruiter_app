import 'package:recruiter_app/core/utils/custom_functions.dart';

class SeekerModel {
  final SeekerPersonalModel? personalData;
  final List<SeekerEmploymetModel>? employmentData;
  final List<SeekerQualificationModel>? qualificationData;

  SeekerModel(
      {this.employmentData,
      this.personalData,
      this.qualificationData,
      });

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
            : null
    );
        
  }
}

class SeekerPersonalModel {
  final User user;
  final Personal personal;
  SeekerPersonalModel({
    required this.user,
    required this.personal,
  });

  factory SeekerPersonalModel.fromJson(Map<String, dynamic> json) {
    return SeekerPersonalModel(
      user: User.fromJson(json["user"]),
      personal: Personal.fromJson(json["personal"]),
      
    );
  }
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? phoneNumber;

  User({this.email, this.id, this.name, this.phoneNumber, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json["email"] ?? "N/A",
        id: json["id"].toString(),
        name: json["name"] ?? "N/A",
        role: json["role"] ?? "N/A",
        phoneNumber: json["username"] ?? "N/A");
  }
}

class Personal {
  final int id;
  final String? introduction;
  final bool? employed;
  final String? city;
  final String? state;
  final String? nationality;
  final String? gender;
  final String? cv;
  final String? profileImage;
  final List<dynamic>? skills;
  final List<dynamic>? languages;
  final List<dynamic>? certificates;
  final List<dynamic>? projects;
  final String? preferedSalaryPackage;
  final List<dynamic>? preferedWorkLocations;
  final String? totalExperienceYears;
  final String? totalExperienceMonths;
  final List<dynamic>? address;
  final String? dob;
  final bool? isDifferentlyAbled;

  Personal(
      {required this.id,
      this.certificates,
      this.city,
      this.cv,
      this.employed,
      this.gender,
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
      this.address,
      this.dob,
      this.isDifferentlyAbled});
  factory Personal.fromJson(Map<String, dynamic> json) {
    return Personal(
        id: json["id"],
        certificates: json["certificates"] ?? [],
        city: json["city"] ?? "N/A",
        cv: json["cv"],
        dob: json["dob"] ?? "N/A",
        employed: json["employed"] ?? false,
        gender: json["gender"] ?? "N/A",
        introduction: json["intro"] ?? "N/A",
        languages: json["languages"] ?? [],
        nationality: json["nationality"] ?? "N/A",
        preferedSalaryPackage: json["prefered_salary_pa"].toString(),
        preferedWorkLocations: json["prefered_work_loc"] ?? [],
        profileImage: CustomFunctions().validateUrl(json["profile_image"] ?? ""),
        projects: json["projects"] ?? [],
        skills: json["skills"] ?? [],
        address: json["address"] ?? [],
        state: json["state"] ?? "N/A",
        isDifferentlyAbled: json["differently_abled"] ?? false,
        totalExperienceMonths: json["total_experience_years"].toString(),
        totalExperienceYears: json["total_experience_months"].toString());
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
