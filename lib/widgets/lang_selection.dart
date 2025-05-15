import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:mnh/widgets/extensions/empty_space.dart';

import '../utils/app_icons.dart';

class CountryBottomSheet extends StatefulWidget {
  @override
  State<CountryBottomSheet> createState() => _CountryBottomSheetState();
}

class _CountryBottomSheetState extends State<CountryBottomSheet> {
  final List<Map<String, String>> countries = [
    {'name': 'English', 'flag': '🇺🇸'},
    {'name': 'Hindi', 'flag': '🇮🇳'},
    {'name': 'Urdu', 'flag': '🇵🇰'},
    {'name': 'Arabic', 'flag': '🇸🇦'},
    {'name': 'Spanish', 'flag': '🇪🇸'},
    {'name': 'German', 'flag': '🇩🇪'},
    {'name': 'Italian', 'flag': '🇮🇹'},
    {'name': 'Chinese', 'flag': '🇨🇳'},
    {'name': 'French', 'flag': '🇫🇷'},
  ];

  String _selectedLanguage = ''; // Initially no language is selected
  String _selectedFlag = ''; // Initially no flag is selected

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Sort the countries list to bring the selected one to the top
    List<Map<String, String>> sortedCountries = countries
        .where((country) => country['name'] == _selectedLanguage)
        .toList() // First the selected language
      ..addAll(countries.where((country) => country['name'] != _selectedLanguage).toList()); // Rest of the languages

    return Row(
      children: [

        InkWell(
          onTap: () {
            // Show the language selection bottom sheet
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  height: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Select a Language',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFFFFAB91)
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: sortedCountries.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: ClipOval(
                                child: Container(
                                  width: 40, // Adjust size of the circle
                                  height: 40, // Adjust size of the circle
                                  color: Colors.grey[200], // Circle background color
                                  child: Center(
                                    child: Text(
                                      sortedCountries[index]['flag']!,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(sortedCountries[index]['name']!),
                              // Highlight selected language and add tick mark only after selection
                              // tileColor: _selectedLanguage == sortedCountries[index]['name']
                              //     ? Colors.blue.shade100
                              //     : null,
                              trailing: _selectedLanguage == sortedCountries[index]['name']
                                  ? Image.asset(AppIcons.checkIcon, scale: 26,)
                                  : null,
                              onTap: () {
                                // Update the selected language and flag when tapped
                                setState(() {
                                  _selectedLanguage = sortedCountries[index]['name']!;
                                  _selectedFlag = sortedCountries[index]['flag']!;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Row(
            children: [
              Text(
                _selectedFlag.isNotEmpty ? _selectedFlag : '🇺🇸', // Default flag if no language is selected
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(width: 8), // Space between the flag and the language
              Text(
                _selectedLanguage.isNotEmpty ? _selectedLanguage : 'English', // Default language if none selected
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Icon(Icons.arrow_drop_down), // Dropdown icon
            ],
          ),
        ),
      ],
    );
  }
}



class LangSelection extends StatefulWidget {
  const LangSelection({super.key});

  @override
  State<LangSelection> createState() => _LangSelectionState();
}

class _LangSelectionState extends State<LangSelection> {
        String selectedCountry = 'Eng';
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    return  Row(
      children: [
        (screenWidth * 0.02).asWidthBox,
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showSearch: false,
              onSelect: (Country country) {
                setState(() {
                  selectedCountry = country.name; // Update selected country
                });
              },
              countryListTheme: CountryListThemeData(
                flagSize: 25,
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                bottomSheetHeight: 600,
                bottomSheetWidth: screenWidth * 1.8,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                inputDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF8C98A8).withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            );
          },
          child: SizedBox(
            width: screenWidth * 0.12,
            child: Text(
              selectedCountry,
              overflow: TextOverflow.ellipsis, // Display the selected country
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        (screenWidth * 0.01).asWidthBox,
        InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              showSearch: false,
              onSelect: (Country country) {
                setState(() {
                  selectedCountry = country.name; // Update selected country
                });
              },
              countryListTheme: CountryListThemeData(
                flagSize: 25,
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                bottomSheetHeight: 600,
                bottomSheetWidth: screenWidth * 1.8,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                inputDecoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF8C98A8).withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}



class RightLangBox extends StatefulWidget {
  const RightLangBox({super.key});

  @override
  State<RightLangBox> createState() => _RightLangBoxState();
}

class _RightLangBoxState extends State<RightLangBox> {
  String selectedCountry = 'Eng';
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none, // Allow overflow of the CircleAvatar
      children: [
        Container(
          width: screenWidth * 0.37,
          height: screenHeight * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              (screenWidth * 0.02).asWidthBox,
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showSearch: false,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country.name; // Update selected country
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      bottomSheetHeight: 600,
                      bottomSheetWidth: screenWidth * 1.8,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      inputDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(Icons.arrow_drop_down),
              ),
              (screenWidth * 0.047).asWidthBox,
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showSearch: false,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country.name; // Update selected country
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      bottomSheetHeight: 600,
                      bottomSheetWidth: screenWidth * 1.8,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      inputDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: screenWidth * 0.12,
                  child: Text(
                    selectedCountry,
                    overflow: TextOverflow.ellipsis, // Display the selected country
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: -8,  // Move the mic icon slightly outside the container
          top: -8,
          bottom: -8,
          child: InkWell(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mic is not working properly'),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                  )
              );
            },
            child: CircleAvatar(
              radius: 25,  // Increase size of the CircleAvatar
              backgroundColor: Colors.blue.shade400, // Adjust size as needed
              child: Image.asset(
                AppIcons.micIcon,
                scale: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}






class LeftLangBox extends StatefulWidget {
  const LeftLangBox({super.key, });

  @override
  State<LeftLangBox> createState() => _LeftLangBoxState();
}

class _LeftLangBoxState extends State<LeftLangBox> {
  String selectedCountry = 'Eng';
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none, // Allow overflow of the CircleAvatar
      children: [
        Container(
          width: screenWidth * 0.35,
          height: screenHeight * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              (screenWidth * 0.02).asWidthBox,
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showSearch: false,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country.name; // Update selected country
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      bottomSheetHeight: 600,
                      bottomSheetWidth: screenWidth * 1.8,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      inputDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: screenWidth * 0.12,
                  child: Text(
                    selectedCountry,
                    overflow: TextOverflow.ellipsis, // Display the selected country
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              (screenWidth * 0.01).asWidthBox,
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showSearch: false,
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = country.name; // Update selected country
                      });
                    },
                    countryListTheme: CountryListThemeData(
                      flagSize: 25,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                      bottomSheetHeight: 600,
                      bottomSheetWidth: screenWidth * 1.8,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      inputDecoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
        Positioned(
          right: -8,  // Move the mic icon slightly outside the container
          top: -8,
          bottom: -8,
          child: InkWell(
            onTap: (){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Mic is not working properly'),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                  )
              );
            },
            child: CircleAvatar(
              radius: 25,  // Increase size of the CircleAvatar
              backgroundColor: Colors.blue.shade400, // Adjust size as needed
              child: Image.asset(
                AppIcons.micIcon,
                scale: 28,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
