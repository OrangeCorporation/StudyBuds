// converts the json object from the response to a group object
import 'package:study_buds/models/profile.dart';
import 'package:study_buds/network/base_http_response.dart';

class ProfileResponseBuilder extends BaseHttpResponseBuilder<Profile> {
  ProfileResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return Profile.fromJson(jsonObject);
        });
}
