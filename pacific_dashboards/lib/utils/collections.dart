class Collections {
  static bool isNullOrEmpty(Iterable iterable) {
    return iterable == null || iterable.isEmpty;
  }
}

extension IterableExt<E extends Object> on Iterable<E> {
  /// Groups the elements in [values] by the value returned by [key].
  ///
  /// Returns a map from keys computed by [key] to a list of all values for which
  /// [key] returns that key. The values appear in the list in the same relative
  /// order as in [values].
  Map<T, List<E>> groupBy<T>(T key(E element)) {
    var map = <T, List<E>>{};
    for (var element in this) {
      var list = map.putIfAbsent(key(element), () => []);
      list.add(element);
    }
    return map;
  }

  List<E> chainSort(int compare(E lv, E rv)) {
    final thisAsList = this.toList();
    thisAsList.sort(compare);
    return this;
  }

  List<T> uniques<T>(T key(E lv)) {
    return this.map((it) => key(it)).toSet().toList();
  }
}

extension Indexed<E> on Iterable<E> {
  Iterable<V> mapIndexed<V>(V Function(int index, E item) f) sync* {
    var index = 0;

    for (final item in this) {
      yield f(index, item);
      index = index + 1;
    }
  }

  void forEachIndexed(void Function(int index, E item) f) {
    var index = 0;

    for (final item in this) {
      f(index, item);
      index = index + 1;
    }
  }
}

List<T> generateIteratingList<T>(
  int startingValue,
  int endingValue,
  int step,
  T Function(int value) transform,
) =>
    [for (int i = startingValue; i <= endingValue; i += step) transform(i)];

extension MapExt<K, V> on Map<K, V> {
  List<T> mapToList<T>(T fn(K key, V value)) {
    final List<T> result = [];
    this.forEach((k, v) {
      result.add(fn(k, v));
    });
    return result;
  }
}
