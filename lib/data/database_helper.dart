import 'models/dynamic_form_local_data/dynamic_form_data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
class DatabaseHelper {
  static const String _boxName = 'dynamic_form_data_models';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DynamicFormDataModelAdapter());
  }

  static Future<Box<DynamicFormDataModel>> openBox() async {
    return await Hive.openBox<DynamicFormDataModel>(_boxName);
  }

  static Future<int> insertFormData(DynamicFormDataModel formData) async {
    final box = await openBox();
    return await box.add(formData);
  }

  static Future<void> updateFormData(int key, DynamicFormDataModel updatedFormData) async {
    final box = await openBox();
    await box.put(key, updatedFormData);
  }

  static Future<void> deleteFormData(int key) async {
    final box = await openBox();
    await box.delete(key);
  }

  static Future<List<DynamicFormDataModel>> getAllFormData() async {
    final box = await openBox();
    return box.values.toList();
  }

  static Future<DynamicFormDataModel?> getFormData(int key) async {
    final box = await openBox();
    return box.get(key);
  }
}
