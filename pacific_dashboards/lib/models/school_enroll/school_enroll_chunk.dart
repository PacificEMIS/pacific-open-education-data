import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';

class SchoolEnrollChunk {
  const SchoolEnrollChunk({
    @required this.schoolData,
    @required this.districtData,
    @required this.nationalData,
  });

  final List<SchoolEnroll> schoolData;
  final List<SchoolEnroll> districtData;
  final List<SchoolEnroll> nationalData;

  // ignore: prefer_constructors_over_static_methods
  static SchoolEnrollChunk fromNonCollapsed(SchoolEnrollChunk chunk) {
    return SchoolEnrollChunk(
      schoolData: _collapseEnrollByYearAndClassLevel(chunk.schoolData),
      districtData: _collapseEnrollByYearAndClassLevel(chunk.districtData),
      nationalData: _collapseEnrollByYearAndClassLevel(chunk.nationalData),
    );
  }

  static List<SchoolEnroll> _collapseEnrollByYearAndClassLevel(
    List<SchoolEnroll> data,
  ) {
    final schoolDataGroupedByYear = data.groupBy((it) => it.year);
    final schoolDataGroupedByYearGroupedByClassLevel =
        <int, Map<String, List<SchoolEnroll>>>{};
    schoolDataGroupedByYear.forEach((key, value) {
      final groupedByClassLevel = value.groupBy((it) => it.classLevel);
      schoolDataGroupedByYearGroupedByClassLevel[key] = groupedByClassLevel;
    });

    final collapsedData = <SchoolEnroll>[];
    schoolDataGroupedByYearGroupedByClassLevel
        .forEach((_, groupedByClassLevel) {
      groupedByClassLevel.forEach((_, listOfSameYearAndClassLevel) {
        if (listOfSameYearAndClassLevel.isNotEmpty) {
          collapsedData.add(
            listOfSameYearAndClassLevel.reduce((lv, rv) => lv + rv),
          );
        }
      });
    });

    return collapsedData;
  }
}
