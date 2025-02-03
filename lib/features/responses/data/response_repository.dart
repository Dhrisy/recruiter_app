import 'package:recruiter_app/services/refresh_token_service.dart';
import 'package:recruiter_app/services/seeker_services/response_seeker_service.dart';

class ResponseRepository {
  Future<String?> editResponse(
      {required int jobId, int? retryCount = 0, int? maxRetries = 3}) async {
    try {
      final response = await ResponseSeekerService.editResponse(jobId: jobId);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        return 'success';
      } else if (response.statusCode == 401) {
        await RefreshTokenService.refreshToken();
        return editResponse(
            jobId: jobId, maxRetries: maxRetries, retryCount: retryCount! + 1);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
