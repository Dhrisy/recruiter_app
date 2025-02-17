import 'dart:io';

abstract class Questionaireevent {}

@override
List<Object?> get props => [];


class QuestionaireSubmitEvent extends Questionaireevent{
  final String website;
  final String aboutCompany;
  final String industry;
  final String functionalArea;
  final String address;
  final String city;
  final String country;
  final String postalCode;
  final String contactPersonName;
  final String mobilePhn;
  final String? landline;
  final String designation;
  final File? logo;


  QuestionaireSubmitEvent({
    this.landline,
    required this.aboutCompany,
    required this.address,
    required this.city,
    required this.contactPersonName,
    required this.country,
    required this.designation,
    required this.functionalArea,
    required this.industry,
    required this.mobilePhn,
    required this.postalCode,
    required this.website,
   required  this.logo,
  });

  List<Object?> get props => [
    aboutCompany,
    address,
    city,
    contactPersonName,
    country,
    designation,
    functionalArea,
    industry,
    mobilePhn,
    postalCode,
    website,
    logo, landline
  ];
}
