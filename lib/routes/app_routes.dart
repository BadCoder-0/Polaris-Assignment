import 'package:demo/presentation/dynamic_form/dynamic_form_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String dynamicFormScreen = '/medical_history_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> get routes => {
        dynamicFormScreen: DynamicFormScreen.builder,
        initialRoute: DynamicFormScreen.builder
      };
}
