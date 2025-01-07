import 'package:recruiter_app/services/api_lists.dart';

class AccountData {
  final String ? id;
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
    this.functionalArea
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
      id: json["id"].toString(),
      logo: validateUrl(json["logo"] ?? ""),
      name: json["name"] ?? "n/a",
      postalCode: json["postal_code"] ?? "n/a",
      website: json["website"] ?? "n/a",
      functionalArea: json["functional_area"] ?? "n/a"

    );
  }


  static String? validateUrl(String? url) {
    const String baseUrl = ApiLists.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    Uri? uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = url.startsWith('/') ? url.substring(1) : url;
        url = baseUrl + url;
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

}