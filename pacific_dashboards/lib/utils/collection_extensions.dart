import 'package:built_collection/built_collection.dart';

extension BuiltExt<E extends Object> on Iterable<E> {
  /// Groups the elements in [values] by the value returned by [key].
  ///
  /// Returns a map from keys computed by [key] to a list of all values for which
  /// [key] returns that key. The values appear in the list in the same relative
  /// order as in [values].
  BuiltMap<T, BuiltList<E>> groupBy<T>(T key(E element)) {
    var map = <T, List<E>>{};
    for (var element in this) {
      var list = map.putIfAbsent(key(element), () => []);
      list.add(element);
    }
    return map.map((key, value) => MapEntry(key, value.build())).build();
  }
}
