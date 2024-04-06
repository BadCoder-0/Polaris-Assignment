import 'package:flutter/material.dart';
class RadioGroupFormField extends StatefulWidget {
  final String label;
  final List<String> options;
  final String mandatory;
  final Function(String?) onChanged;
  final GlobalKey<FormState> formKey;
  final bool showError; // Add showError parameter

  RadioGroupFormField({
    required this.label,
    required this.options,
    required this.mandatory,
    required this.onChanged,
    required this.formKey,
    required this.showError, // Initialize showError
  });

  @override
  _RadioGroupFormFieldState createState() => _RadioGroupFormFieldState();
}

class _RadioGroupFormFieldState extends State<RadioGroupFormField> {
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
        Wrap(
          spacing: 10, // Adjust the spacing between radio buttons
          children: List.generate(widget.options.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOption = widget.options[index];
                });
                widget.onChanged(_selectedOption);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: 16), // Adjust the padding around each option
                margin: EdgeInsets.only(bottom: 5), // Add margin between lines
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey),
                  color: _selectedOption == widget.options[index]
                      ? Colors.blue
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedOption == widget.options[index]
                            ? Colors.white
                            : Colors.transparent,
                        border: Border.all(
                            color: _selectedOption == widget.options[index]
                                ? Colors.blue
                                : Colors.grey),
                      ),
                      child: _selectedOption == widget.options[index]
                          ? Icon(Icons.check,
                          size: 12, color: Colors.blue)
                          : null,
                    ),
                    SizedBox(width: 5), // Add space between the checkbox and text
                    Text(
                      widget.options[index],
                      style: TextStyle(
                        color: _selectedOption == widget.options[index]
                            ? Colors.white
                            : Colors.black,
                        fontWeight: _selectedOption == widget.options[index]
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        if (widget.showError && widget.mandatory == 'yes' && _selectedOption == null)
          Text(
            'Please select ${widget.label}',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
