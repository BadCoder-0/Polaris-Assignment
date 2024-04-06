import 'package:demo/presentation/dynamic_form/models/form_model.dart';
import 'package:demo/widgets/capture_image.dart';
import 'package:demo/widgets/check_box_group.dart';
import 'package:demo/widgets/drop_down.dart';
import 'package:demo/widgets/radio_group.dart';
import 'package:demo/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:demo/core/app_export.dart';
import 'provider/dynamic_form_provider.dart';
class DynamicFormScreen extends StatefulWidget {
  const DynamicFormScreen({Key? key})
      : super(
          key: key,
        );

  @override
  DynamicFormScreenState createState() => DynamicFormScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DynamicFromProvider(),
      child: DynamicFormScreen(),
    );
  }
}

class DynamicFormScreenState extends State<DynamicFormScreen> {
  @override
  void initState() {
    Provider.of<DynamicFromProvider>(context,listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: DynamicForm(),
      ),
    );
  }
}
class DynamicForm extends StatefulWidget {

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formValues = {};
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DynamicFromProvider>(
        builder: (context, dynamicFormProvider, child) => Form(
      key: _formKey,
      child: Column(
        children: [
          dynamicFormProvider.errorStatus?Center(child: CircularProgressIndicator()):
          Expanded(
            child: ListView.builder(
              itemCount: dynamicFormProvider.formData.fields.length,
              itemBuilder: (context, index) {
                var field = dynamicFormProvider.formData.fields[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: buildField(field),
                );
              },
            ),
          ),
          SubmitButton(formValues: formValues, toggleError: toggleError),
        ],
      ),
    ));
  }

  void toggleError(bool showError) {
    setState(() {
      _showError = showError;
    });
  }

  Widget buildField(Field field) {
    switch (field.componentType) {
      case 'EditText':
        return CustomFormField(
          initialValue: formValues[field.metaInfo.label]??"",
          validator: (input){
            if (field.metaInfo.mandatory == 'yes' && (input == null || input.isEmpty)) {
              return 'Please enter ${field.metaInfo.label}';
            }
            return null;
          },
          labelText: field.metaInfo.label,
          hintText: 'Enter ${field.metaInfo.label}',
          prefixIcon: field.metaInfo.componentInputType == 'INTEGER' ? Icons.phone : Icons.person,
          keyboardType: field.metaInfo.componentInputType == 'INTEGER' ? TextInputType.number : TextInputType.text,
          mandatory: field.metaInfo.mandatory,
          onChanged: (value) {
            setState(() {
              formValues[field.metaInfo.label] = value;
            });

          },
        );
      case 'CheckBoxes':
        return CheckboxGroupFormField(
          showError: _showError,
          label: field.metaInfo.label,
          options: field.metaInfo.options ?? [],
          mandatory: field.metaInfo.mandatory,
          onChanged: (List<String> values) {
            formValues[field.metaInfo.label] = values;
          },
        );
      case 'DropDown':
        return DropdownFormField(
          label: field.metaInfo.label,
          options: field.metaInfo.options ?? [],
          mandatory: field.metaInfo.mandatory,
          formKey: _formKey,
          onChanged: (String? value) {
            formValues[field.metaInfo.label] = value;
          },
        );
      case 'CaptureImages':
        return CaptureImagesField(
          label: field.metaInfo.label,
          noOfImagesToCapture: 1,
          savingFolder: "",
          onChanged: (List<String> imagePaths) {
            formValues[field.metaInfo.label] = imagePaths;
          },
        );
      case 'RadioGroup':
        return RadioGroupFormField(
          showError: _showError,
          formKey: _formKey,
          label: field.metaInfo.label,
          options: field.metaInfo.options ?? [],
          mandatory: field.metaInfo.mandatory,
          onChanged: (String? value) {
            formValues[field.metaInfo.label] = value;
          },
        );
      default:
        return Container();
    }
  }
}



class SubmitButton extends StatelessWidget {
  final Map<String, dynamic> formValues;
  final Function(bool) toggleError;

  SubmitButton({required this.formValues, required this.toggleError});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Toggle error message
        toggleError(true);
        // Validate form
        if (Form.of(context).validate()) {
          Provider.of<DynamicFromProvider>(context,listen: false).submitData(context, formValues);
        }
      },
      child: Text('Submit'),
    );

  }
}
