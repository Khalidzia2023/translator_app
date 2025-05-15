

class LanguagePair {
  final String language;
  final String sentence;

  LanguagePair({required this.language, required this.sentence});
}

class OnboardingInfo {
  final String title;
  final String descriptions;
  final List<LanguagePair> languagePairs;

  OnboardingInfo({
    required this.title,
    required this.descriptions,
    required this.languagePairs,
  });
}

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
      title: "Voice Translator",
      descriptions: "Speak and translate each word in any language",
      languagePairs: [
        LanguagePair(language: "English", sentence: "I am not afraid of storms, for I am learning how to sail my ship."),
        LanguagePair(language: "Spanish", sentence: "No tengo miedo a las tormentas, porque estoy aprendiendo a navegar mi barco."),
      ],
    ),
    OnboardingInfo(
      title: "Pronunciation",
      descriptions: "Learn how to Pronounce each word correctly",
      languagePairs: [
        LanguagePair(language: "English", sentence: "Learn english with spelling and pronunciation expert "),
        // LanguagePair(language: "Arabic", sentence: "هذا مثال على النطق."),
        LanguagePair(language: "Arabic", sentence: "الجميع يتكلمون ولكن ليس بشكل صحيح"),
      ],
    ),
    OnboardingInfo(
      title: "Spell Checker",
      descriptions: "No spelling mistakes with AI Powered Spell Checker",
      languagePairs: [
        LanguagePair(language: "English", sentence: "Be careful with spelling mistakes."),
        LanguagePair(language: "Spanish", sentence: "Ten cuidado con los errores de ortografía."),
      ],
    ),



  ];
}