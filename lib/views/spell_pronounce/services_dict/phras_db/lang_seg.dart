import 'package:flutter/material.dart';
import 'package:mnh/views/spell_pronounce/services_dict/phras_db/phras_db.dart';

class LangSeg extends StatefulWidget {
  @override
  _LangSegState createState() => _LangSegState();
}

class _LangSegState extends State<LangSeg> {
  List<String> languages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    try {
      // Fetch languages from the database
      final data = await DatabaseHelper.instance.getLanguages();
      print("Fetched languages: $data"); // Debugging output

      if (data.isEmpty) {
        print("No languages found in database.");
      }

      setState(() {
        languages = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching languages: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Languages")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : languages.isEmpty
          ? Center(child: Text("No languages found"))
          : ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index]),
          );
        },
      ),
    );
  }
}
