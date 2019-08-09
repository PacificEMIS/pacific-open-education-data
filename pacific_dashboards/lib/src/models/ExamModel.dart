class ExamModel {
  final String exam;
  final int examYear;
  final String districtCode;
  final String examStandard;
  final String examBenchmark;
  final int candidatesM;
  final int candidatesF;
  final List<int> resultsM;
  final List<int> resultsF;

  ExamModel({
    this.exam,
    this.examYear,
    this.districtCode,
    this.examStandard,
    this.examBenchmark,
    this.candidatesM,
    this.candidatesF,
    this.resultsM,
    this.resultsF,
  });

  factory ExamModel.fromJson(Map parsedJson) {
    return ExamModel(
      exam: parsedJson['Exam'] ?? "",
      examYear: parsedJson['ExamYear'] ?? 0,
      districtCode: parsedJson['DistrictCode'] ?? "",
      examStandard: parsedJson['ExamStandard'] ?? "",
      examBenchmark: parsedJson['ExamBenchmark'] ?? "",
      candidatesM: parsedJson['CandidatesM'] ?? 0,
      candidatesF: parsedJson['CandidatesF'] ?? 0,
      resultsM: [
        parsedJson['1M'] ?? 0,
        parsedJson['ApproachingCompetenceM'] ?? 0,
        parsedJson['MinimallyCompetentM'] ?? 0,
        parsedJson['CompetentM'] ?? 0
      ],
      resultsF: [
        parsedJson['WellBelowCompetentF'] ?? 0,
        parsedJson['ApproachingCompetenceF'] ?? 0,
        parsedJson['MinimallyCompetentF'] ?? 0,
        parsedJson['CompetentF'] ?? 0
      ],
    );
  }

  factory ExamModel.sum(ExamModel one, ExamModel two) {
    return ExamModel(
      exam: one.exam,
      examYear: one.examYear,
      districtCode: one.districtCode,
      examStandard: one.examStandard,
      examBenchmark: one.examBenchmark,
      candidatesM: one.candidatesM + two.candidatesM,
      candidatesF: one.candidatesF + two.candidatesF,
      resultsM: [
        one.resultsM[0] + two.resultsM[0],
        one.resultsM[1] + two.resultsM[1],
        one.resultsM[2] + two.resultsM[2],
        one.resultsM[3] + two.resultsM[3],
      ],
      resultsF: [
        one.resultsF[0] + two.resultsF[0],
        one.resultsF[1] + two.resultsF[1],
        one.resultsF[2] + two.resultsF[2],
        one.resultsF[3] + two.resultsF[3],
      ],
    );
  }

  Map<String, dynamic> toJson() => {
    'Exam': exam,
    'ExamYear': examYear,
    'DistrictCode': districtCode,
    'ExamStandard': examStandard,
    'ExamBenchmark': examBenchmark,
    'CandidatesM': candidatesM,
    'CandidatesF': candidatesF,
    '1M': resultsM[0],
    'ApproachingCompetenceM': resultsM[1],
    'MinimallyCompetentM': resultsM[2],
    'CompetentM': resultsM[3],
    'WellBelowCompetentF': resultsF[0],
    'ApproachingCompetenceF': resultsF[1],
    'MinimallyCompetentF': resultsF[2],
    'CompetentF': resultsF[3],
  };
}