

import 'package:recruiter_app/core/utils/custom_functions.dart';

class AccountData {
  final int ? id;
  final String ? name;
  final String ? logo;
  final String ? about;
  final String ? website;
  final List<dynamic> ? address;
  final String ? city;
  final String ? country;
  final String ? postalCode;
  final String ? contactName;
  final String ? contactLandNumber;
  final String ? contactMobileNumber;
  final String ? designation;
  final String? functionalArea;
  final String? industry;




  AccountData({
    this.about,
    this.address,
    this.city,
    this.contactLandNumber,
    this.contactMobileNumber,
    this.contactName,
    this.country,
    this.designation,
    this.id,
    this.logo,
    this.name,
    this.postalCode,
    this.website,
    this.functionalArea,
    this.industry
  });



  factory AccountData.fromJson(Map<String, dynamic>  json){
    return AccountData(
      about: json["about"] ?? "n/a",
      address: json["address"] ?? [],
      city: json["city"] ?? "n/a",
      contactLandNumber: json["contact_land_number"] ?? "n/a",
      contactMobileNumber: json["contact_mobile_number"] ?? "n/a",
      contactName: json["contact_name"] ?? "n/a",
      country: json["country"] ?? "n/a",
      designation: json["designation"] ?? "n/a",
      id: json["id"],
      logo: CustomFunctions().validateUrl(json["logo"].toString()),
      name: json["name"] ?? "n/a",
      postalCode: json["postal_code"] ?? "n/a",
      website: json["website"] ?? "n/a",
      functionalArea: json["functional_area"] ?? "n/a",
      industry: json["industry"] ?? "n/a"
      

    );
  }
}



class UserModel{
  final String email;
  final String phone;
  final int id;
  final String name;

  UserModel({
    required this.email,
    required this.phone,
    required this.id,
    required this.name
  });


  factory UserModel.fromJson(Map<String, dynamic> json){
    return UserModel(
      email: json["email"],
      phone: json["username"],
      id: json["id"],
      name: json["name"]
    );
  }
}



class UserData {
  final AccountData? accountModel;
  final UserModel userModel;

  UserData({
    this.accountModel,
    required this.userModel,
  });

  // Factory constructor to create UserData from UserModel and AccountData
  factory UserData.fromModels({
    required UserModel userModel,
    AccountData? accountModel,
  }) {
    return UserData(
      userModel: userModel,
      accountModel: accountModel,
    );
  }
}