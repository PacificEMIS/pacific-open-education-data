import 'package:json_annotation/json_annotation.dart';
import 'package:pacific_dashboards/models/short_school/short_school.dart';

part 'schools_list_response_body.g.dart';

@JsonSerializable()
class SchoolsListResponseBody {
  SchoolsListResponseBody();

  factory SchoolsListResponseBody.fromJson(Map<String, dynamic> json) =>
      _$SchoolsListResponseBodyFromJson(json);

  @JsonKey(name: 'ResultSet')
  List<ShortSchool> schools;

  Map<String, dynamic> toJson() => _$SchoolsListResponseBodyToJson(this);
}
