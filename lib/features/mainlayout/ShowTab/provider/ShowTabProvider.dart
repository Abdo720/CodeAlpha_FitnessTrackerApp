import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:fitness/core/resources/firebase/constantfounctions.dart';
import 'package:fitness/features/AddTab/data/ExModel/ExModel.dart';

class Showtabprovider extends ChangeNotifier {
  int selectedIndex = 0;

  List<ExModel> ex = [];

  String category = Conests.activityCategories[0];

  // Stream subscription for real-time updates
  var _exStreamSubscription;

  @override
  void dispose() {
    // Cancel stream subscription when provider is disposed
    _exStreamSubscription?.cancel();
    super.dispose();
  }

  void changeIndex(int index) {
    selectedIndex = index;
    category = Conests.activityCategories[selectedIndex];
    listenToExStream(category);
  }

  // Real-time listening method
  void listenToExStream(String category) {
    try {
      // Cancel previous subscription
      _exStreamSubscription?.cancel();

      // Listen to new stream
      _exStreamSubscription = FireBaseConestFounctions.getExsStream(category)
          .listen(
            (snapshot) {
              ex = snapshot.docs.map((doc) => doc.data()).toList();
              notifyListeners();
            },
            onError: (e) {
              debugPrint("Error listening to exercises: $e");
            },
          );
    } catch (e) {
      debugPrint("Error setting up stream listener: $e");
    }
  }

  // Legacy method for compatibility
  Future<void> getEx(String category) async {
    listenToExStream(category);
  }

  Future<void> updateEx(ExModel model) async {
    try {
      await FireBaseConestFounctions.updateEx(model);
      // No need to call getEx() - stream will update automatically
    } catch (e) {
      debugPrint("Error updating exercise: $e");
    }
  }

  Future<void> deleteEx(ExModel model) async {
    try {
      await FireBaseConestFounctions.deleteEx(model);
      // No need to call getEx() - stream will update automatically
    } catch (e) {
      debugPrint("Error deleting exercise: $e");
    }
  }
}
