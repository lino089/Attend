class ScheduleModel {
  final String className;
  final String startTime;
  final String subject;
  final String location;
  final String endTime;
  final bool isOnGoing;
  final int colorCode;

  ScheduleModel({
    required this.className,
    this.subject = '',
    required this.startTime,
    required this.endTime,
    this.location = '',
    this.isOnGoing = false,
    this.colorCode = 0xFF4A65E5,
  });
}
