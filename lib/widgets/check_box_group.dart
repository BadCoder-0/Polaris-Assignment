import 'package:flutter/material.dart';

class CheckboxGroupFormField extends StatefulWidget {
  final String label;
  final List<String> options;
  final String mandatory;
  final Function(List<String>) onChanged;
  final bool showError; // Add showError parameter

  CheckboxGroupFormField({
    required this.label,
    required this.options,
    required this.mandatory,
    required this.onChanged,
    required this.showError, // Initialize showError
  });

  @override
  _CheckboxGroupFormFieldState createState() =>
      _CheckboxGroupFormFieldState();
}

class _CheckboxGroupFormFieldState extends State<CheckboxGroupFormField> {
  Set<String> _selectedOptions = {};

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
        Wrap(
          spacing: 8,
          children: List.generate(widget.options.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _selectedOptions.contains(widget.options[index]),
                  onChanged: (isChecked) {
                    _selectedOptions.clear();
                    setState(() {
                      if (isChecked!) {
                        _selectedOptions.add(widget.options[index]);
                      } else {
                        _selectedOptions.remove(widget.options[index]);
                      }
                    });
                    widget.onChanged(_selectedOptions.toList());
                  },
                ),
                Text(
                  widget.options[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          }),
        ),
        // Show error message if showError is true and no option is selected
        if (widget.showError &&
            widget.mandatory == 'yes' &&
            _selectedOptions.isEmpty)
          Text(
            'Please select at least one option',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant CheckboxGroupFormField oldWidget) {
    if (widget.showError != oldWidget.showError) {
      // If showError flag changes, rebuild the widget
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }
}
