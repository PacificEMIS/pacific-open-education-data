class Collections {
  static bool isNullOrEmpty(Iterable iterable) {
    return iterable == null || iterable.isEmpty;
  }
}

extension ArchIterableExt<E> on Iterable<E> {
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
    return thisAsList;
  }

  List<T> uniques<T>(T key(E it)) {
    return this.map((it) => key(it)).toSet().toList();
  }

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

  E get head {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }

  List<E> get tail {
    if (this.length < 2) {
      return [];
    }
    final list = this.toList();
    return list.sublist(1);
  }
}

extension ArchMapExt<K, V> on Map<K, V> {
  List<T> mapToList<T>(T fn(K key, V value)) {
    final List<T> result = [];
    this.forEach((k, v) {
      result.add(fn(k, v));
    });
    return result;
  }
}
