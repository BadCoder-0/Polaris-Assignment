import 'dart:convert';

import 'package:demo/data/models/dynamic_form_local_data/dynamic_form_data_model.dart';
import 'package:demo/presentation/dynamic_form/models/form_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../../core/app_export.dart';

class DynamicFromProvider extends ChangeNotifier {
  // Instantiate NetworkInfo class
  final NetworkInfo _networkInfo = NetworkInfo();

  // Use _networkInfo to check connectivity
  void checkConnectivity() async {
    bool isConnected = await _networkInfo.isConnected();
    print('Is connected to the internet: $isConnected');

    ConnectivityResult result = await _networkInfo.connectivityResult;
    print('Connectivity result: $result');

    _networkInfo.onConnectivityChanged.listen((result) {
      print('Connectivity changed: $result');
    });

    // Start background service
    startBackgroundService();
  }

  void startBackgroundService() async {
    // Listen to background service data received
    FlutterBackgroundService().onDataReceived.listen((event) async {
      // Check connectivity when the background service starts
      ConnectivityResult result = await _networkInfo.connectivityResult;
      print('Connectivity result: $result');
      sendDataPeriodically(await fetchFormData());
      // You can perform actions based on connectivity status here
      // For example, if there's no internet connection, you can show a notification
    });
  }
bool _hasError = false;
  bool get errorStatus=>_hasError;
  late FormData formData;
  void fetchData() async {
    _hasError = true;
    String url = 'https://chatbot-api.grampower.com/flutter-assignment';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        // Bind the data to FormData class
        formData  = FormData.fromJson(jsonData);
        notifyListeners();
      } else {
        print('Error fetching data: ${response.statusCode}');
      }
      _hasError = false;
    } catch (e) {
      print('Exception occurred: $e');
      _hasError = false;
    }
  }
  Future<void> submitData(BuildContext context, Map<String, dynamic> formData) async {
    bool isConnected = await NetworkInfo().isConnected();

    if (isConnected) {
        await sendDataPeriodically(formData);
    } else {
      // If not connected, store data in Hive
      var box = await Hive.openBox<DynamicFormDataModel>('consumers');
        String name = formData['Consumer Name'];
        String mobileNumber = formData['Consumer Mobile Number'];
        List<String> consumerStatus = [formData['Consumer Status']];
        String meterStatus = formData['Meter Status'];
        String phaseType = formData['Phase Type'];
        String meterValidationStatus = formData['Meter Validation Status'];

        // Create a DynamicFormDataModel object
        var dynamicFormDataModel = DynamicFormDataModel(
          name: name,
          mobileNumber: mobileNumber,
          consumerStatus: consumerStatus,
          meterStatus: meterStatus,
          phaseType: phaseType,
          meterValidationStatus: meterValidationStatus,
        );
        // Insert data into Hive
        await box.add(dynamicFormDataModel);

      await box.close();

      // Notify user that data has been inserted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data inserted into Hive'),
          // Provide a builder parameter to handle user actions
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> fetchFormData() async {
    var box = await Hive.openBox<DynamicFormDataModel>('consumers');
    Map<String, dynamic> formDataMap = {};

    // Fetch data using keys
    List<int> keys = box.keys.cast<int>().toList();
    for (var key in keys) {
      var formData = await box.get(key);
      formDataMap[key.toString()] = formData!.toJson(); // Assuming DynamicFormDataModel has a toJson() method
    }

    // Or fetch data using values
    // List<DynamicFormDataModel> dataList = box.values.toList();
    // for (var formData in dataList) {
    //   formDataMap[formData.key] = formData.toJson(); // Assuming DynamicFormDataModel has a key property
    // }

    await box.close();

    return formDataMap;
  }
  Future<void> sendDataPeriodically(Map<String, dynamic> formData) async {
    String url = 'https://chatbot-api.grampower.com/flutter-assignment/push';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Create a DynamicFormDataModel object
    var dynamicFormDataModel = DynamicFormDataModel(
      name: formData['Consumer Name'],
      mobileNumber: formData['Consumer Mobile Number'],
      consumerStatus: formData['Consumer Status'],
      meterStatus: formData['Meter Status'],
      phaseType: formData['Phase Type'],
      meterValidationStatus: formData['Meter Validation Status'],
    );

    // Convert DynamicFormDataModel to JSON
    String jsonData = jsonEncode({
      "data": [
        {
          "form_name": dynamicFormDataModel.name,
          "mobile_number": dynamicFormDataModel.mobileNumber,
          "consumer_status": dynamicFormDataModel.consumerStatus,
          "meter_status": dynamicFormDataModel.meterStatus,
          "phase_type": dynamicFormDataModel.phaseType,
          "meter_validation_status": dynamicFormDataModel.meterValidationStatus,
        }
      ]
    });

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Data posted successfully.');
        print('Response body: ${response.body}');
      } else {
        print('Error posting data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
