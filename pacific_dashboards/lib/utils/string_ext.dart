extension StringExt on String {
  String ifEmpty(String replacement) => isEmpty ? replacement : this;
}