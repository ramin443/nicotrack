// class OnboardingData {
//   // Private fields
//   String _lastSmokedDate = "";
//   int _cigarettesPerDay = -1;
//   String _costOfAPack = "";
//   int _numberOfCigarettesIn1Pack = -1;
//   List<String> _biggestMotivation = [];
//   List<String> _craveSituations = [];
//   List<String> _helpNeeded = [];
//   int _quitMethod = -1;
//   String _name = "";
//   // Constructor with optional named params (with default values)
//   OnboardingData();
//
//   // Getters
//   String get lastSmokedDate => _lastSmokedDate;
//   int get cigarettesPerDay => _cigarettesPerDay;
//   String get costOfAPack => _costOfAPack;
//   int get numberOfCigarettesIn1Pack => _numberOfCigarettesIn1Pack;
//   List<String> get biggestMotivation => _biggestMotivation;
//   List<String> get craveSituations => _craveSituations;
//   List<String> get helpNeeded => _helpNeeded;
//   int get quitMethod => _quitMethod;
//   String get name => _name;
//
//   // Setters
//   set lastSmokedDate(String value) => _lastSmokedDate = value;
//   set cigarettesPerDay(int value) => _cigarettesPerDay = value;
//   set costOfAPack(String value) => _costOfAPack = value;
//   set numberOfCigarettesIn1Pack(int value) => _numberOfCigarettesIn1Pack = value;
//   set biggestMotivation(List<String> value) => _biggestMotivation = value;
//   set craveSituations(List<String> value) => _craveSituations = value;
//   set helpNeeded(List<String> value) => _helpNeeded = value;
//   set quitMethod(int value) => _quitMethod = value;
//   set name(String value) => _name = value;
//
//   Map<String, dynamic> toJson() {
//     return {
//       'lastSmokedDate': _lastSmokedDate,
//       'cigarettesPerDay': _cigarettesPerDay,
//       'costOfAPack': _costOfAPack,
//       'numberOfCigarettesIn1Pack': _numberOfCigarettesIn1Pack,
//       'biggestMotivation': _biggestMotivation,
//       'craveSituations': _craveSituations,
//       'helpNeeded': _helpNeeded,
//       'quitMethod': _quitMethod,
//       'name': _name,
//     };
//   }
//
// }