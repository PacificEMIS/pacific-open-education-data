import 'package:json_annotation/json_annotation.dart';

part 'token_response_body.g.dart';

@JsonSerializable()
class TokenResponseBody {
  TokenResponseBody();

  factory TokenResponseBody.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseBodyFromJson(json);

  @JsonKey(name: 'access_token')
  String accessToken;

  Map<String, dynamic> toJson() => _$TokenResponseBodyToJson(this);
}
