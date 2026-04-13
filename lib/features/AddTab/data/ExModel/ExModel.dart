import 'package:flutter/material.dart';

class ExModel {
  String id;
  bool isDone;
  String category;
  String time;
  String cal;
  int date;

  ExModel({
    this.id = " ",
    this.isDone = false,
    required this.category,
    required this.time,
    required this.cal,
    required this.date,
  });

  // fromJson
  ExModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        isDone: json['isDone'],
        category: json['category'],
        time: json['time'],
        cal: json['cal'],
        date: json['date'],
      );
  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDone': isDone,
      'category': category,
      'time': time,
      'cal': cal,
      'date': date,
    };
  }
}
