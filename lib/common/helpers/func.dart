class Func {
  static Map<String, dynamic> timeConverter(int minute) {
    int hours = minute ~/ 60;
    int minutes = minute % 60;
    print("{hour : $hours,minute:$minutes }");
    return {"hour": hours==0?"":hours, "minute": minutes==0?"":minutes};
  }
}
