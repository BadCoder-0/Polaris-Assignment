import 'package:hive/hive.dart';

part 'dynamic_form_data_model.g.dart';

@HiveType(typeId: 0)
class DynamicFormDataModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String mobileNumber;

  @HiveField(2)
  List<String> consumerStatus;

  @HiveField(3)
  String meterStatus;

  @HiveField(4)
  String phaseType;

  @HiveField(5)
  String meterValidationStatus;

  DynamicFormDataModel({
    required this.name,
    required this.mobileNumber,
    required this.consumerStatus,
    required this.meterStatus,
    required this.phaseType,
    required this.meterValidationStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'consumerStatus': consumerStatus,
      'meterStatus': meterStatus,
      'phaseType': phaseType,
      'meterValidationStatus': meterValidationStatus,
    };
  }
}
