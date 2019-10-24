import 'package:pacific_dashboards/src/models/SchoolAccreditationsModel.dart';

class SchoolAccreditationsChunk {
  SchoolAccreditationsChunk({this.statesChunk, this.standardsChunk});

  final SchoolAccreditationsModel statesChunk;
  final SchoolAccreditationsModel standardsChunk;

  factory SchoolAccreditationsChunk.fromJson(Map parsedJson) {
    return SchoolAccreditationsChunk(
      statesChunk:
          SchoolAccreditationsModel.fromJson(parsedJson['statesChunk']),
      standardsChunk:
          SchoolAccreditationsModel.fromJson(parsedJson['standardsChunk']),
    );
  }

  Map<String, dynamic> toJson() => {
        'statesChunk': statesChunk.toJson(),
        'standardsChunk': standardsChunk.toJson(),
      };
}
