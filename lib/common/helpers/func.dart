class Func {
  static Map<String, dynamic> timeConverterMinToHour(int minute) {
    int hours = minute ~/ 60;
    int minutes = minute % 60;
    print("{hour : $hours,minute:$minutes }");
    return {"hour": hours==0?"":hours, "minute": minutes==0?"":minutes};
  }
  static int timeConverterSecToMin(int sec) {
    int minutes = sec % 60;
    print("minute:$minutes");
    return minutes;
  }
}
