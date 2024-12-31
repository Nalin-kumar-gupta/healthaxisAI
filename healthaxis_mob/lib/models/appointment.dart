
class Appointment {
  final String id;
  final String doctorId;
  final String patientName;
  final DateTime date;
  final String status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientName,
    required this.date,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctorId'],
      patientName: json['patientName'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientName': patientName,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
