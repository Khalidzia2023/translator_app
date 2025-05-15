import 'package:flutter/material.dart';

class LanguageSelection extends StatefulWidget {
  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  int _selectedValue = 0; // Default selected index
  final List<String> _languages = ['English', 'Spanish', 'Hindi'];

  void _onChanged(int? value) {
    if (value != null) {
      setState(() {
        _selectedValue = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your language:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                _languages.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _selectedValue,
                        onChanged: _onChanged,
                        activeColor: Colors.indigo,
                        fillColor: MaterialStateProperty.resolveWith(
                              (states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.indigo; // Indigo for selected
                            }
                            return Colors.grey; // Grey for unselected
                          },
                        ),
                      ),
                      Text(
                        _languages[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedValue == index
                              ? Colors.indigo
                              : Colors.grey, // Match text color to selection
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Selected Language: ${_languages[_selectedValue]}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
