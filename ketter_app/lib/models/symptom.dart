class SymptomInfo {
  final String name;
  final String snomedCode;

  const SymptomInfo(this.name, this.snomedCode);
}

class SymptomDefinitions {
  static const Map<String, String> symptomToSnomed = {
    'Fatigue': '84229001',
    'Nausea': '422587007',
    'Skin changes/Rash': '271807003',
    'Joint pain': '57676002',
    'Swelling/Edema': '267038008',
    'Shortness of breath': '267036007',
    'Palpitations': '80313002',
    'Anxiety': '48694002',
    'Dizziness': '404640003',
    'Headache': '25064002',
    'Tinnitus': '60413006',
    'Mouth sores': '26284000',
    'Sexual dysfunction': '231532002',
    'Constipation': '14760008',
    'Dry eyes': '401111007',
  };

  static const Map<String, String> severityToSnomed = {
    'mild': '255604002',
    'moderate': '6736007',
    'severe': '24484000',
  };
}
