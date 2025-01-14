import 'package:study_buds/network/base_http_response.dart';

import '../../models/student.dart';

class ProfileResponseBuilder extends BaseHttpResponseBuilder<Student> {
  ProfileResponseBuilder()
      : super(dataFactory: (jsonObject) {
          return Student.fromJson(jsonObject);
        });
}
