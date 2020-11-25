import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  @JsonKey(name: 'QID')
  final String id;

  @JsonKey(name: "QName")
  final String name;

  @JsonKey(name: "QFlags")
  final String qFlags;

  bool _isValidForApp;

  Question(this.id, this.name, this.qFlags);

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  bool get isValidForApp {
    if (_isValidForApp == null) {
      if (qFlags?.isNotEmpty ?? false) {
        final flags = qFlags
            .split("|")
            .map((e) => _createFlagFromJsonName(e))
            .where((e) => e != null)
            .toList();

        final type = _QuestionType.fromFlags(flags.sum);

        _isValidForApp = type != null &&
            (type is _QuestionTypeSingleSelection ||
                type is _QuestionTypeMultiSelection ||
                type is _QuestionTypeBinary ||
                type is _QuestionTypeTernary);
      } else {
        _isValidForApp = false;
      }
    }
    return _isValidForApp;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          qFlags == other.qFlags;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ qFlags.hashCode;
}

class _QuestionType {
  const _QuestionType();

  factory _QuestionType.fromFlags(int flagSum) {
    if (flagSum == _QuestionTypeBinary.flags.sum) {
      return _QuestionTypeBinary();
    }
    if (flagSum == _QuestionTypeTernary.flags.sum) {
      return _QuestionTypeTernary();
    }
    if (flagSum == _QuestionTypeTextInput.flags.sum) {
      return _QuestionTypeTextInput();
    }
    if (flagSum == _QuestionTypeNumberInput.flags.sum) {
      return _QuestionTypeNumberInput();
    }
    if (flagSum == _QuestionTypePhoneInput.flags.sum) {
      return _QuestionTypePhoneInput();
    }
    if (flagSum == _QuestionTypeGeolocation.flags.sum) {
      return _QuestionTypeGeolocation();
    }
    if (flagSum == _QuestionTypePhoto.flags.sum) {
      return _QuestionTypePhoto();
    }
    if (flagSum == _QuestionTypeSingleSelection.flags.sum) {
      return _QuestionTypeSingleSelection();
    }
    if (flagSum == _QuestionTypeMultiSelection.flags.sum) {
      return _QuestionTypeMultiSelection();
    }
    if (flagSum == _QuestionTypeComplexBinary.flags.sum) {
      return _QuestionTypeComplexBinary();
    }
    if (flagSum == _QuestionTypeComplexNumberInput.flags.sum) {
      return _QuestionTypeComplexNumberInput();
    }
    return null;
  }
}

extension _FlagListExt on List<_QuestionTypeFlag> {
  int get sum => this.fold(0, (acc, it) => acc | it.value);
}

class _QuestionTypeBinary extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.binary,
  ];
  const _QuestionTypeBinary() : super();
}

class _QuestionTypeTernary extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.ternary,
  ];
  const _QuestionTypeTernary() : super();
}

class _QuestionTypeTextInput extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.input,
  ];
  const _QuestionTypeTextInput() : super();
}

class _QuestionTypeNumberInput extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.input,
    _QuestionTypeFlag.numeric,
  ];
  const _QuestionTypeNumberInput() : super();
}

class _QuestionTypePhoneInput extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.input,
    _QuestionTypeFlag.phone,
  ];
  const _QuestionTypePhoneInput() : super();
}

class _QuestionTypeGeolocation extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.geo,
  ];
  const _QuestionTypeGeolocation() : super();
}

class _QuestionTypePhoto extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.photo,
  ];
  const _QuestionTypePhoto() : super();
}

class _QuestionTypeSingleSelection extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.choose,
    _QuestionTypeFlag.single,
  ];
  const _QuestionTypeSingleSelection() : super();
}

class _QuestionTypeMultiSelection extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.choose,
    _QuestionTypeFlag.multiple,
  ];
  const _QuestionTypeMultiSelection() : super();
}

class _QuestionTypeComplexBinary extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.variable,
    _QuestionTypeFlag.binary,
  ];
  const _QuestionTypeComplexBinary() : super();
}

class _QuestionTypeComplexNumberInput extends _QuestionType {
  static const flags = [
    _QuestionTypeFlag.variable,
    _QuestionTypeFlag.input,
    _QuestionTypeFlag.numeric,
  ];
  const _QuestionTypeComplexNumberInput() : super();
}

enum _QuestionTypeFlag {
  binary,
  input,
  numeric,
  choose,
  single,
  multiple,
  variable,
  photo,
  geo,
  ternary,
  phone,
}

extension _QuestionTypeFlagExt on _QuestionTypeFlag {
  int get value => pow(2, this.index);
}

_QuestionTypeFlag _createFlagFromJsonName(String jsonName) {
  switch (jsonName) {
    case "BINARY":
      return _QuestionTypeFlag.binary;
    case "INPUT":
      return _QuestionTypeFlag.input;
    case "NUMERIC":
      return _QuestionTypeFlag.numeric;
    case "CHOOSE":
      return _QuestionTypeFlag.choose;
    case "SINGLE":
      return _QuestionTypeFlag.single;
    case "MULTIPLE":
      return _QuestionTypeFlag.multiple;
    case "VAR":
      return _QuestionTypeFlag.variable;
    case "PHOTO":
      return _QuestionTypeFlag.photo;
    case "GEO":
      return _QuestionTypeFlag.geo;
    case "TERNARY":
      return _QuestionTypeFlag.ternary;
    case "PHONE":
      return _QuestionTypeFlag.phone;
  }
  return null;
}
