import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final List<String> tileTitle;
  final List<String>? tileSubTitle;
  final Color tileColor;
  final List<Widget>? tileLeading;
  final int? selectedValue;
  final ValueChanged<int?>? onChanged;
  final Color? borderColor;

  CustomTile({
    super.key,
    required this.tileTitle,
    this.tileSubTitle,
    required this.tileColor,
    this.tileLeading,
    this.selectedValue,
    this.onChanged,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tileTitle.length,
      itemBuilder: (context, index) {
        Color currentBorderColor = selectedValue == index ? (borderColor ?? Color(0XFF4169E1).withValues(alpha: .76)) : Colors.transparent;
        Color currentTileColor = selectedValue == index ? Colors.white70 : tileColor; // Change tile color based on selection

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GestureDetector(
            onTap: () {
              if (onChanged != null) {
                onChanged!(index); // Update selected value
              }
            },
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: currentBorderColor,
                  width: 2,
                ),
                color: currentTileColor,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2.3),
                    color: Colors.grey.shade400,
                    spreadRadius: 1.0,
                    blurRadius: 2
                  )
                ]
              ),
              child: ListTile(
                dense: true,
                leading: tileLeading?[index],
                title: Text(
                  tileTitle[index],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(tileSubTitle?[index] ?? ''),
                trailing: Radio<int>(
                  value: index,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    if (onChanged != null) {
                      onChanged!(value); // Notify parent about selection
                    }
                  },
                  activeColor: Colors.deepOrange.shade400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

