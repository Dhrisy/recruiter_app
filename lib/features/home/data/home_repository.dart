import 'package:recruiter_app/services/home_services/count_service.dart';

class HomeRepository {
  Future<void>  fetchRecruiterCounts() async{
    try {
      final response = await CountService.fetchRecruiterCounts();
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      
    }
  }
}