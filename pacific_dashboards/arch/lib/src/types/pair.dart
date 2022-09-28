class Pair<F, S> {
  final F first;
  final S second;

  const Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          first == other.first &&
          second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}