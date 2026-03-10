class ScheduleModel {
  final String className;
  final String subject;
  final String startTime;
  final String endTime;
  final String location;
  final bool isOngoing;
  final int colorCode;

  ScheduleModel({
    this.subject = '',
    this.location = '',
    this.colorCode = 0xFF5169F6,
    required this.className,
    required this.startTime,
    required this.endTime,
    this.isOngoing = false,
  });
}
