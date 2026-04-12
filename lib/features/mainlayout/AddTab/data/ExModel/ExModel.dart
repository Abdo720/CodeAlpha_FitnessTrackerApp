class ExModel {
  String id = "";
  bool isDone = false;
  String? category;
  int? time;
  int? date;

  ExModel({
    required this.id,
    required this.isDone,
    required this.category,
    required this.time,
    required this.date,
  });

  // fromJson
  ExModel.fromJson(Map<String, dynamic> json) {
    ExModel(
      id: json['id'],
      isDone: json['isDone'],
      category: json['category'],
      time: json['time'],
      date: json['date'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDone': isDone,
      'category': category,
      'time': time,
      'date': date,
    };
  }
}
