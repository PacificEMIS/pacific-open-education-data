class VersionModel {
  final int major;
  final int minor;
  final int build;

  VersionModel({
    this.major,
    this.minor,
    this.build,
  });

  factory VersionModel.fromJson(Map<String, dynamic> parsedJson) {
    return VersionModel(
      major: parsedJson['major'],
      minor: parsedJson['minor'],
      build: parsedJson['build'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'major': major,
      'minor': minor,
      'build': build,
    };
  }

  @override
  bool operator ==(dynamic other) {
    if (other is! VersionModel) return false;
    VersionModel version = other;
    return (version.build == build &&
        version.minor == minor &&
        version.major == major);
  }

  @override
  int get hashCode {
    int result = 17;
    result = 37 * result + major.hashCode;
    result = 37 * result + minor.hashCode;
    result = 37 * result + build.hashCode;

    return result;
  }
}
