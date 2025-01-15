import 'package:hive/hive.dart';

part 'response_body.g.dart';

@HiveType(typeId: 0)
class ResponseBody extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String data;

  ResponseBody({required this.id, required this.data});
}