 import 'package:arch/arch.dart';
import 'package:flutter/material.dart';
import 'package:pacific_dashboards/models/school_enroll/school_enroll.dart';

class SchoolEnrollChunk {
  final List<SchoolEnroll> schoolData;
  final List<SchoolEnroll> districtData;
  final List<SchoolEnroll> nationalData;

  const SchoolEnrollChunk({
    @required this.schoolData,
    @required this.districtData,
    @required this.nationalData,
  });

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
    final Map<int, Map<String, List<SchoolEnroll>>>
        schoolDataGroupedByYearGroupedByClassLevel = {};
    schoolDataGroupedByYear.forEach((key, value) {
      final groupedByClassLevel = value.groupBy((it) => it.classLevel);
      schoolDataGroupedByYearGroupedByClassLevel[key] = groupedByClassLevel;
    });

    final List<SchoolEnroll> collapsedData = [];
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
