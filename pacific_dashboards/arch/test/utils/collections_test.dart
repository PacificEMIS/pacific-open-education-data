import 'package:flutter_test/flutter_test.dart';

import 'package:arch/arch.dart';

void main() {
  group('isNullOrEmpty', () {
    test('isNullOrEmpty true when null', () {
      expect(Collections.isNullOrEmpty(null), true);
    });
    test('isNullOrEmpty true when empty list passed', () {
      expect(Collections.isNullOrEmpty([]), true);
    });
    test('isNullOrEmpty true when empty set passed', () {
      expect(Collections.isNullOrEmpty({}), true);
    });
    test('isNullOrEmpty false when non-empty list passed', () {
      expect(Collections.isNullOrEmpty(['test']), false);
    });
    test('isNullOrEmpty false when non-empty set passed', () {
      expect(Collections.isNullOrEmpty({'test', 'test2'}), false);
    });
  });

  group('groupBy', () {
    test('groupBy is grouping (empty)', () {
      final collection = [];
      final expectedGroupedByIdCollection = {};
      final expectedGroupedByValueCollection = {};
      expect(collection.groupBy((it) => it.id), expectedGroupedByIdCollection);
      expect(
        collection.groupBy((it) => it.value),
        expectedGroupedByValueCollection,
      );
    });

    test('groupBy is grouping (have null in grouping)', () {
      final collection = [
        _SimpleClass(1, 'value1'),
        _SimpleClass(null, 'value2'),
        _SimpleClass(3, 'value3'),
        _SimpleClass(4, null),
      ];
      final expectedGroupedByIdCollection = {
        1: [_SimpleClass(1, 'value1')],
        null: [_SimpleClass(null, 'value2')],
        3: [_SimpleClass(3, 'value3')],
        4: [_SimpleClass(4, null)],
      };
      final expectedGroupedByValueCollection = {
        'value1': [_SimpleClass(1, 'value1')],
        'value2': [_SimpleClass(null, 'value2')],
        'value3': [_SimpleClass(3, 'value3')],
        null: [_SimpleClass(4, null)],
      };
      expect(collection.groupBy((it) => it.id), expectedGroupedByIdCollection);
      expect(
        collection.groupBy((it) => it.value),
        expectedGroupedByValueCollection,
      );
    });

    test('groupBy is grouping (all unique)', () {
      final collection = [
        _SimpleClass(1, 'value1'),
        _SimpleClass(2, 'value2'),
        _SimpleClass(3, 'value3'),
        _SimpleClass(4, 'value4'),
      ];
      final expectedGroupedByIdCollection = {
        1: [_SimpleClass(1, 'value1')],
        2: [_SimpleClass(2, 'value2')],
        3: [_SimpleClass(3, 'value3')],
        4: [_SimpleClass(4, 'value4')],
      };
      final expectedGroupedByValueCollection = {
        'value1': [_SimpleClass(1, 'value1')],
        'value2': [_SimpleClass(2, 'value2')],
        'value3': [_SimpleClass(3, 'value3')],
        'value4': [_SimpleClass(4, 'value4')],
      };
      expect(collection.groupBy((it) => it.id), expectedGroupedByIdCollection);
      expect(
        collection.groupBy((it) => it.value),
        expectedGroupedByValueCollection,
      );
    });

    test('groupBy is grouping', () {
      final collection = [
        _SimpleClass(1, 'value1'),
        _SimpleClass(2, 'value2'),
        _SimpleClass(3, 'value3'),
        _SimpleClass(4, 'value4'),
        _SimpleClass(1, 'value11'),
        _SimpleClass(22, 'value2'),
        _SimpleClass(3, 'value33'),
        _SimpleClass(44, 'value4'),
      ];
      final expectedGroupedByIdCollection = {
        1: [
          _SimpleClass(1, 'value1'),
          _SimpleClass(1, 'value11'),
        ],
        2: [
          _SimpleClass(2, 'value2'),
        ],
        3: [
          _SimpleClass(3, 'value3'),
          _SimpleClass(3, 'value33'),
        ],
        4: [
          _SimpleClass(4, 'value4'),
        ],
        22: [
          _SimpleClass(22, 'value2'),
        ],
        44: [
          _SimpleClass(44, 'value4'),
        ],
      };
      final expectedGroupedByValueCollection = {
        'value1': [
          _SimpleClass(1, 'value1'),
        ],
        'value2': [
          _SimpleClass(2, 'value2'),
          _SimpleClass(22, 'value2'),
        ],
        'value3': [
          _SimpleClass(3, 'value3'),
        ],
        'value4': [
          _SimpleClass(4, 'value4'),
          _SimpleClass(44, 'value4'),
        ],
        'value11': [
          _SimpleClass(1, 'value11'),
        ],
        'value33': [
          _SimpleClass(3, 'value33'),
        ],
      };
      expect(collection.groupBy((it) => it.id), expectedGroupedByIdCollection);
      expect(
        collection.groupBy((it) => it.value),
        expectedGroupedByValueCollection,
      );
    });
  });

  group('chainSort', () {
    test('chainSort with empty collection', () {
      expect(<int>[].chainSort((lv, rv) => lv.compareTo(rv)), <int>[]);
    });

    test('chainSort tests', () {
      expect(
        [1, 2, 3, 4, 5].chainSort((lv, rv) => lv.compareTo(rv)),
        [1, 2, 3, 4, 5],
      );
      expect(
        [1, 2, 3, 4, 5].chainSort((lv, rv) => rv.compareTo(lv)),
        [5, 4, 3, 2, 1],
      );
      expect(
        [12, 33, -1, 0.25, 12e-4].chainSort((lv, rv) => lv.compareTo(rv)),
        [-1, 12e-4, 0.25, 12, 33],
      );
      expect(
        ['a', 'z', 'r', 'f'].chainSort((lv, rv) => lv.compareTo(rv)),
        ['a', 'f', 'r', 'z'],
      );
    });
  });

  group('uniques', () {
    test('uniques with empty collection', () {
      expect(<_SimpleClass>[].uniques((it) => it.id), <int>[]);
      expect(<_SimpleClass>[].uniques((it) => it.value), <String>[]);
    });

    test('uniques with uniques', () {
      final collection = [
        _SimpleClass(1, 'value1'),
        _SimpleClass(2, 'value2'),
        _SimpleClass(3, 'value3'),
        _SimpleClass(4, 'value4'),
      ];
      final uniqueIds = [1, 2, 3, 4];
      final uniqueValues = [
        'value1',
        'value2',
        'value3',
        'value4',
      ];
      expect(collection.uniques((it) => it.id), uniqueIds);
      expect(collection.uniques((it) => it.value), uniqueValues);
    });

    test('uniques is dropping non-unique', () {
      final collection = [
        _SimpleClass(1, 'value1'),
        _SimpleClass(2, 'value2'),
        _SimpleClass(3, 'value3'),
        _SimpleClass(4, 'value4'),
        _SimpleClass(1, 'value11'),
        _SimpleClass(22, 'value2'),
        _SimpleClass(3, 'value33'),
        _SimpleClass(44, 'value4'),
      ];
      final uniqueIds = [1, 2, 3, 4, 22, 44];
      final uniqueValues = [
        'value1',
        'value2',
        'value3',
        'value4',
        'value11',
        'value33',
      ];
      expect(collection.uniques((it) => it.id), uniqueIds);
      expect(collection.uniques((it) => it.value), uniqueValues);
    });
  });

  group('head', () {
    test('head is null in empty collections', () {
      expect([].head, null);
    });
    test('head found in collection with length == 1', () {
      expect([1].head, 1);
    });
    test('head found in collection with length > 1', () {
      expect([1, 2, 3, 4, 5, 6].head, 1);
    });
  });

  group('tail', () {
    test('tail is empty in empty collections', () {
      expect([].tail, []);
    });
    test('tail is empty in collection with length == 1', () {
      expect([1].tail, []);
    });
    test('tail found collection with length > 1', () {
      expect([1, 2].tail, [2]);
      expect([1, 2, 3, 4, 5, 6, 7].tail, [2, 3, 4, 5, 6, 7]);
    });
  });

  group('mapIndexed', () {
    test('mapIndexed is empty in empty collections', () {
      expect(
          <int>[].mapIndexed((index, item) => '[$index] = $item'), <String>[]);
    });
    test('mapIndexed works in non-empty collections', () {
      expect(
        <int>[1, 3, 5, 7, 9].mapIndexed((index, item) => '[$index] = $item'),
        <String>[
          '[0] = 1',
          '[1] = 3',
          '[2] = 5',
          '[3] = 7',
          '[4] = 9',
        ],
      );
    });
  });

  group('forEachIndexed', () {
    test('forEachIndexed works in non-empty collections', () {
      final List<String> resultCollection = [];
      [1, 3, 5, 7, 9].forEachIndexed((index, item) {
        resultCollection.add('[$index] = $item');
      });
      expect(
        resultCollection,
        <String>[
          '[0] = 1',
          '[1] = 3',
          '[2] = 5',
          '[3] = 7',
          '[4] = 9',
        ],
      );
    });
  });

  group('mapToList', () {
    test('mapToList return empty List for empty Map', () {
      expect(
        <int, String>{}.mapToList((key, value) => '$key -> $value'),
        <String>[],
      );
    });
    test('mapToList works in non-empty collections', () {
      expect(
        {
          1: 'one',
          3: 'three',
          5: 'five',
          7: 'seven',
          9: 'nine',
        }.mapToList(
          (key, value) => '$key -> $value',
        ),
        [
          '1 -> one',
          '3 -> three',
          '5 -> five',
          '7 -> seven',
          '9 -> nine',
        ],
      );
    });
  });
}

class _SimpleClass {
  final int id;
  final String value;

  const _SimpleClass(this.id, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _SimpleClass &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          value == other.value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;

  @override
  String toString() {
    return '_SimpleClass{id: $id, value: $value}';
  }
}
