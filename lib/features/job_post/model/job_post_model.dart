class JobPostModel {
  String? title;
  String? description;
  String? jobType;
  String? city;
  String? country;
  int? vaccancy;
  String? industry;
  String? functionalArea;
  String? gender;
  String? nationality;
  int? minimumExperience;
  int? maximumExperience;
  String? candidateLocation;
  String? education;
  int? minimumSalary;
  int? maximumSalary;
  // String? description;
  // String? jobType;
  // String? city;
  // String? country;

  JobPostModel(
      {this.candidateLocation,
      this.city,
      this.country,
      this.description,
      this.education,
      this.functionalArea,
      this.gender,
      this.industry,
      this.jobType,
      this.maximumExperience,
      this.maximumSalary,
      this.minimumExperience,
      this.minimumSalary,
      this.nationality,
      this.title,
      this.vaccancy});

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      candidateLocation: json["candidate_location"] ?? "N/A",
      city: json["city"] ?? "N/A",
      country: json["country"] ?? "N/A",
      description: json["description"] ?? "N/A",
      education: json["candidate_education"] ?? "N/A",
      functionalArea: json["functional_area"] ?? "N/A",
      gender: json["gender"] ?? "N/A",
      industry: json["industry"] ?? "N/A",
      jobType: json["experience_min"] ?? 0,
      minimumExperience: json["experience_max"] ?? 0,
      maximumSalary: json["salary_max"] ?? 0,
      minimumSalary: json["salary_min"] ?? 0,
      nationality: json["nationality"] ?? "N/A",
      title: json["title"] ?? "N/A",
      vaccancy: json["vaccancy"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "candidate_location": candidateLocation,
      "city": city,
      "country": country,
      "description": description,
      "candidate_education": education,
      "functional_area": functionalArea,
      "gender": gender,
      "industry": industry,
      "experience_max": maximumExperience,
      "experience_min": minimumExperience,
      "salary_min": minimumSalary,
      "salary_max": maximumSalary,
      "title": title,
      "nationality": nationality,
      "vaccancy": vaccancy
    };
  }
}
