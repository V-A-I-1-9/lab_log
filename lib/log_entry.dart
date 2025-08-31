class LogEntry {
  final String id;
  final String title;
  final String observations;
  final DateTime date;
  final String? imagePath;

  LogEntry({
    required this.id,
    required this.title,
    required this.observations,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'observations': observations,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      id: json['id'],
      title: json['title'],
      observations: json['observations'],
      date: DateTime.parse(json['date']),
      imagePath: json['imagePath'],
    );
  }
}
