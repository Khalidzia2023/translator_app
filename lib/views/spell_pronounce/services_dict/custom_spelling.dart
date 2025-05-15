import 'package:flutter/material.dart';
import 'package:languagetool_textfield/languagetool_textfield.dart';


class checkSpelling extends StatefulWidget {
  const checkSpelling({super.key});

  @override
  State<checkSpelling> createState() => _checkSpellingState();
}

class _checkSpellingState extends State<checkSpelling> {
  final LanguageToolController _controller = LanguageToolController();
  static const List<MainAxisAlignment> alignments = [
    MainAxisAlignment.center,
    MainAxisAlignment.start,
    MainAxisAlignment.end,
  ];
  int currentAlignmentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: alignments[currentAlignmentIndex],
            children: [
              LanguageToolTextField(
                controller: _controller,
                // language: 'en-US',
              ),
              DropdownMenu(
                hintText: "Select alignment...",
                onSelected: (value) => setState(() {
                  currentAlignmentIndex = value ?? 0;
                }),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 0, label: "Center alignment"),
                  DropdownMenuEntry(value: 1, label: "Top alignment"),
                  DropdownMenuEntry(value: 2, label: "Bottom alignment"),
                ],
              ),
            ],
          ),
        ),
      ),
    );}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}
