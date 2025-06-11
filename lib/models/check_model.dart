import 'package:hive/hive.dart';

part 'check_model.g.dart';

@HiveType(typeId: 0)
class CheckModel extends HiveObject {
  @HiveField(0)
  String placeName;

  @HiveField(1)
  List<Map<String, String>> positions;

  @HiveField(2)
  double? tax;

  @HiveField(3)
  List<String> imagesPaths;

  @HiveField(4)
  String? placeAddress;

  @HiveField(5)
  String? personalAssessment;

  @HiveField(6)
  String date;

  @HiveField(7)
  double? tipPercentage;

  @HiveField(8)
  int? splitCount;

  CheckModel({
    required this.placeName,
    required this.positions,
    this.tax,
    required this.imagesPaths,
    this.placeAddress,
    this.personalAssessment,
    required this.date,
    this.tipPercentage,
    this.splitCount,
  });
}
