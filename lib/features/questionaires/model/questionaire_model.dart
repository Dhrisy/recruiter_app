class QuestionaireModel {
  final String website;
  final String about;
  final String industry;
  final String functionalArea;
  final String address;
  final String city;
  final String country;
  final String postalCode;
  final String mobileNumber;
  final String designation;
  final String? landlineNumber;
  final String contactPersonName;
  final String? logo;


  QuestionaireModel({
    this.landlineNumber,
    required this.about,
    required this.industry,
    required this.functionalArea,
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
    required this.mobileNumber,
    required this.designation,
    required this.website,
    required this.contactPersonName,
    this.logo,

  });

}