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
  List<dynamic>? candidateLocation;
  String? education;
  int? minimumSalary;
  int? maximumSalary;
   String? requirements;
   String? benefits;
   List<dynamic>? skills;
   List<dynamic>? customQuestions;
   String? currency;
   int? id;
   String? createdOn;
   bool? status;

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
      this.vaccancy,
      this.benefits,
      this.customQuestions,
      this.requirements,
      this.skills,
      this.currency,
      this.id,
      this.createdOn,
      this.status
      });

   

  factory JobPostModel.fromJson(Map<String, dynamic> json) {
    return JobPostModel(
      candidateLocation: json["candidate_location"] ,
      city: json["city"] ,
      country: json["country"] ,
      description: json["description"] ,
      education: json["education"] ,
      functionalArea: json["functional_area"] ,
      gender: json["gender"] ,
      industry: json["industry"] ,
      jobType: json["type"] ,
      minimumExperience: json["experience_min"] ,
      maximumExperience: json["experience_max"] ,
      maximumSalary: json["salary_max"] ,
      minimumSalary: json["salary_min"] ,
      nationality: json["nationality"] ,
      title: json["title"] ,
      vaccancy: json["vacancy"],
      benefits: json["benefits"],
      skills: json["skills"],
      customQuestions: json["custon_qns"],
      currency: json["currency"],
      id: json["id"],
      createdOn: json["created_on"],
      status: json["active"]
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
      "vacancy": vaccancy,
      "requirements": requirements,
      "benefits": benefits,
      "custom_qns": customQuestions,
      "currency": currency
    };
  }
}
