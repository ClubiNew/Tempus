String getFirestoreDate(DateTime date) {
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');
  return "${date.year}-$month-$day";
}
