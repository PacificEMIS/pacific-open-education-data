import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
@immutable

/// field [_isValidForApp] is immutable lazy value
// ignore: must_be_immutable
class Question {
  Question(this.id, this.name, this.qFlags);

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  @JsonKey(name: 'QID')
  final String id;

  @JsonKey(name: 'QName')
  final String name;

  @JsonKey(name: 'QFlags')
  final String qFlags;

  bool _isValidForApp;

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  bool get isValidForApp {
    if (_isValidForApp == null) {
      if (qFlags != null) {
        final flags = qFlags
            .split('|')
            .map(_createFlagFromJsonName)
            .where((e) => e != null)
            .toList();

        final type = _QuestionType.fromFlags(flags.sum);

        _isValidForApp = type != null &&
            (type is _QuestionTypeSingleSelection ||
                type is _QuestionTypeMultiSelection ||
                type is _QuestionTypeBinary ||
                type is _QuestionTypeTernary);
      } else {
        _isValidForApp = qFlags == null;
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
      return const _QuestionTypeBinary();
    }
    if (flagSum == _QuestionTypeTernary.flags.sum) {
      return const _QuestionTypeTernary();
    }
    if (flagSum == _QuestionTypeTextInput.flags.sum) {
      return const _QuestionTypeTextInput();
    }
    if (flagSum == _QuestionTypeNumberInput.flags.sum) {
      return const _QuestionTypeNumberInput();
    }
    if (flagSum == _QuestionTypePhoneInput.flags.sum) {
      return const _QuestionTypePhoneInput();
    }
    if (flagSum == _QuestionTypeGeolocation.flags.sum) {
      return const _QuestionTypeGeolocation();
    }
    if (flagSum == _QuestionTypePhoto.flags.sum) {
      return const _QuestionTypePhoto();
    }
    if (flagSum == _QuestionTypeSingleSelection.flags.sum) {
      return const _QuestionTypeSingleSelection();
    }
    if (flagSum == _QuestionTypeMultiSelection.flags.sum) {
      return const _QuestionTypeMultiSelection();
    }
    if (flagSum == _QuestionTypeComplexBinary.flags.sum) {
      return const _QuestionTypeComplexBinary();
    }
    if (flagSum == _QuestionTypeComplexNumberInput.flags.sum) {
      return const _QuestionTypeComplexNumberInput();
    }
    return null;
  }
}

extension _FlagListExt on List<_QuestionTypeFlag> {
  int get sum => fold(0, (acc, it) => acc | it.value);
}

class _QuestionTypeBinary extends _QuestionType {
  const _QuestionTypeBinary() : super();

  static const flags = [
    _QuestionTypeFlag.binary,
  ];
}

class _QuestionTypeTernary extends _QuestionType {
  const _QuestionTypeTernary() : super();

  static const flags = [
    _QuestionTypeFlag.ternary,
  ];
}

class _QuestionTypeTextInput extends _QuestionType {
  const _QuestionTypeTextInput() : super();

  static const flags = [
    _QuestionTypeFlag.input,
  ];
}

class _QuestionTypeNumberInput extends _QuestionType {
  const _QuestionTypeNumberInput() : super();

  static const flags = [
    _QuestionTypeFlag.input,
    _QuestionTypeFlag.numeric,
  ];
}

class _QuestionTypePhoneInput extends _QuestionType {
  const _QuestionTypePhoneInput() : super();

  static const flags = [
    _QuestionTypeFlag.input,
    _QuestionTypeFlag.phone,
  ];
}

class _QuestionTypeGeolocation extends _QuestionType {
  const _QuestionTypeGeolocation() : super();

  static const flags = [
    _QuestionTypeFlag.geo,
  ];
}

class _QuestionTypePhoto extends _QuestionType {
  const _QuestionTypePhoto() : super();

  static const flags = [
    _QuestionTypeFlag.photo,
  ];
}

class _QuestionTypeSingleSelection extends _QuestionType {
  const _QuestionTypeSingleSelection() : super();

  static const flags = [
    _QuestionTypeFlag.choose,
    _QuestionTypeFlag.single,
  ];
}

class _QuestionTypeMultiSelection extends _QuestionType {
  const _QuestionTypeMultiSelection() : super();

  static const flags = [
    _QuestionTypeFlag.choose,
    _QuestionTypeFlag.multiple,
  ];
}

class _QuestionTypeComplexBinary extends _QuestionType {
  const _QuestionTypeComplexBinary() : super();

  static const flags = [
    _QuestionTypeFlag.variable,
    _QuestionTypeFlag.binary,
  ];
}

class _QuestionTypeComplexNumberInput extends _QuestionType {
  const _QuestionTypeComplexNumberInput() : super();

  static const flags = [
    _QuestionTypeFlag.variable,
    _QuestionTypeFlag.input,
    _QuestionTypeFlag.numeric,
  ];
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
  int get value => pow(2, index);
}

_QuestionTypeFlag _createFlagFromJsonName(String jsonName) {
  switch (jsonName) {
    case 'BINARY':
      return _QuestionTypeFlag.binary;
    case 'INPUT':
      return _QuestionTypeFlag.input;
    case 'NUMERIC':
      return _QuestionTypeFlag.numeric;
    case 'CHOOSE':
      return _QuestionTypeFlag.choose;
    case 'SINGLE':
      return _QuestionTypeFlag.single;
    case 'MULTIPLE':
      return _QuestionTypeFlag.multiple;
    case 'VAR':
      return _QuestionTypeFlag.variable;
    case 'PHOTO':
      return _QuestionTypeFlag.photo;
    case 'GEO':
      return _QuestionTypeFlag.geo;
    case 'TERNARY':
      return _QuestionTypeFlag.ternary;
    case 'PHONE':
      return _QuestionTypeFlag.phone;
  }
  return null;
}
