import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/features/AddTab/data/ExModel/ExModel.dart';

class FireBaseConestFounctions {
  static CollectionReference<ExModel> getExCollection() {
    return FirebaseFirestore.instance
        .collection("Ex")
        .withConverter<ExModel>(
          fromFirestore: (snapshot, options) {
            return ExModel.fromJson(snapshot.data()!);
          },
          toFirestore: (value, options) {
            return value.toJson();
          },
        );
  }

  static Future<void> cerateEx(ExModel model) {
    var collection = getExCollection();
    var docRef = collection.doc();
    model.id = docRef.id;
    return docRef.set(model);
  }

  static Future<void> updateEx(ExModel model) {
    var collection = getExCollection();
    var docRef = collection.doc(model.id);
    return docRef.update(model.toJson());
  }

  static Future<void> deleteEx(ExModel model) {
    var collection = getExCollection();
    var docRef = collection.doc(model.id);
    return docRef.delete();
  }

  // One-time read (kept for compatibility)
  static Future<QuerySnapshot<ExModel>> getExs(String category) async {
    var collection = getExCollection();
    var data = await collection.where("category", isEqualTo: category).get();
    return data;
  }

  // Real-time stream for exercises by category
  static Stream<QuerySnapshot<ExModel>> getExsStream(String category) {
    var collection = getExCollection();
    return collection.where("category", isEqualTo: category).snapshots();
  }

  // One-time read (kept for compatibility)
  static Future<QuerySnapshot<ExModel>> getExsIsDone() async {
    var collection = getExCollection();
    var data = await collection.where("isDone", isEqualTo: true).get();
    return data;
  }

  // Real-time stream for done exercises
  static Stream<QuerySnapshot<ExModel>> getExsIsDoneStream() {
    var collection = getExCollection();
    return collection.where("isDone", isEqualTo: true).snapshots();
  }

  static Stream<QuerySnapshot<ExModel>> getExsToChartOfDayStream(
    String category,
  ) {
    var collection = getExCollection();

    DateTime now = DateTime.now();

    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    return collection
        .where(
          "date",
          isGreaterThanOrEqualTo: startOfDay.millisecondsSinceEpoch,
        )
        .where("date", isLessThan: endOfDay.millisecondsSinceEpoch)
        .where("isDone", isEqualTo: true)
        .where("category", isEqualTo: category)
        .snapshots();
  }

  static Stream<QuerySnapshot<ExModel>> getExsToChartOfWeekStream() {
    var collection = getExCollection();

    DateTime now = DateTime.now();

    // بداية النهاردة
    DateTime endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: 1));

    // بداية الأسبوع (من 6 أيام قبل النهاردة)
    DateTime startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: 6));

    return collection
        .where(
          "date",
          isGreaterThanOrEqualTo: startOfWeek.millisecondsSinceEpoch,
        )
        .where("date", isLessThan: endOfDay.millisecondsSinceEpoch)
        .where("isDone", isEqualTo: true)
        .snapshots();
  }
}
