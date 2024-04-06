import 'package:flutter/material.dart';
class DropdownFormField extends StatefulWidget {
  final String label;
  final List<String> options;
  final String mandatory;
  final Function(String?) onChanged;
  final GlobalKey<FormState> formKey; // Add a GlobalKey<FormState>

  DropdownFormField({
    required this.label,
    required this.options,
    required this.mandatory,
    required this.onChanged,
    required this.formKey, // Accept a GlobalKey<FormState>
  });

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedOption,
            items: widget.options
                .map((option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                    color: Colors
                        .black), // Customize dropdown value text color
              ),
            ))
                .toList(),
            onChanged: (String? value) {
              setState(() {
                _selectedOption = value;
              });
              widget.onChanged(value);
            },
            validator: (value) {
              if (widget.mandatory == 'yes' && value == null) {
                return 'Please select ${widget.label}';
              }
              return null;
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24.0,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            iconEnabledColor: Colors.black,
            hint: Text(
              'Select ${widget.label}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}