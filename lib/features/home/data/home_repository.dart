import 'dart:convert';

import 'package:recruiter_app/features/home/model/banner_model.dart';
import 'package:recruiter_app/features/home/model/count_model.dart';
import 'package:recruiter_app/services/home_services/banner_service.dart';
import 'package:recruiter_app/services/home_services/count_service.dart';
import 'package:recruiter_app/services/refresh_token_service.dart';

class HomeRepository {
  Future<CountModel?> fetchRecruiterCounts(
      {int? retryCount = 0, int? maxRetries = 3}) async {
    try {
      final response = await CountService.fetchRecruiterCounts();
      print("count response ${response.body}");

      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        CountModel countData = CountModel.fromJson(responseData);
        return countData;
      } else if (response.statusCode == 401) {
       
        await RefreshTokenService.refreshToken();
        return fetchRecruiterCounts(maxRetries: 3, retryCount: retryCount! + 1);
      } else {
        return null;
      }
    } catch (e) {
      print("Unexpected errorrrrrrrrrrrrrr $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?>  fetchBanners({
    int? retryCount = 0,
    int? maxRetries = 3
  }) async{
    try{
final response = await BannerService.fetchBanners();
print("response of banners  ${response.statusCode},  ${response.body}");

if(response.statusCode == 200){
  final List<dynamic> responseData = jsonDecode(response.body);

  List<BannerModel> banners = responseData.map((item)
  => BannerModel.fromJson(item)).toList();

  return {
    "list": banners,
    "message": "success"
  };
  
}else if(response.statusCode == 401){
  await RefreshTokenService.refreshToken();
return fetchBanners(
  retryCount: retryCount! + 1,
  maxRetries: maxRetries
);
}else{
  final Map<String, dynamic> responseData = jsonDecode(response.body);
return {
    "list": null,
    "message": responseData["message"]
  };

}
    }catch(e){
return {
    "list": null,
    "message": e.toString(),
  };
    }
  }
}
