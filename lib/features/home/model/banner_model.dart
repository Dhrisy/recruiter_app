import 'package:recruiter_app/core/utils/custom_functions.dart';

class BannerModel{
  final int id;
  final String? image;

  BannerModel({
    required this.id,
    required this.image,
  });


  factory BannerModel.fromJson(Map<String, dynamic> json){
    return BannerModel(
       id: json["id"],
       image: CustomFunctions().validateUrl(json["image"])
    );
  }
}