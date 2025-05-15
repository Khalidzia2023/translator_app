import 'package:flutter/material.dart';

class DropdownBtn extends StatefulWidget {
  final String selectedValue;
  final List<String> dropdownItems;
  final ValueChanged<String?> onChanged;

  const DropdownBtn({
    super.key,
    required this.selectedValue,
    required this.dropdownItems,
    required this.onChanged,
  });

  @override
  State<DropdownBtn> createState() => _DropdownBtnState();
}

class _DropdownBtnState extends State<DropdownBtn> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(

      value: widget.dropdownItems.contains(widget.selectedValue)
          ? widget.selectedValue
          : widget.dropdownItems[0],
      isExpanded: false,
      onChanged: (String? newValue) {
        widget.onChanged(newValue);
      },
      items: widget.dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
