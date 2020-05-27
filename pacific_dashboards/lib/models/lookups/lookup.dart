import 'package:flutter/foundation.dart';

class Lookup {
  final String code;
  final String name;
  final String l;

  const Lookup({
    @required this.code,
    @required this.name,
    @required this.l,
  });

  factory Lookup.fromJson(Map<String, dynamic> json) {
    return Lookup(
      code: json['C'],
      name: json['N'],
      l: json['L'],
    );
  }
}
