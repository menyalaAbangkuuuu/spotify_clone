String formatDuration(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);
  String hour = duration.inHours.remainder(60).toString().padLeft(2);
  String minute = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  return "${hour}h ${minute}m";
}
