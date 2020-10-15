import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';

part 'schools_list_response_body.g.dart';

@JsonSerializable()
class SchoolsListResponseBody {
  @JsonKey(name: 'ResultSet')
  List<ShortSchool> schools;

  SchoolsListResponseBody();

  factory SchoolsListResponseBody.fromJson(Map<String, dynamic> json) =>
      _$SchoolsListResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SchoolsListResponseBodyToJson(this);
}
