import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String? initialValue;
  final String? mandatory;
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;

  CustomFormField({
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.keyboardType,
    required this.mandatory,
    this.validator,
    this.onChanged,
    this.initialValue,
  });

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: widget.onChanged,
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: Icon(widget.prefixIcon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            errorText: _errorText,
          ),
          keyboardType: widget.keyboardType,
          validator: widget.validator
        ),
        SizedBox(height: 0), // Add space between fields
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
