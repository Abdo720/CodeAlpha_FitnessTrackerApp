import 'package:fitness/core/resources/firebase/constantfounctions.dart';
import 'package:fitness/features/AddTab/data/ExModel/ExModel.dart';
import 'package:flutter/material.dart';

class Showdoneprovider extends ChangeNotifier {
  List<ExModel> doneEx = [];

  // Stream subscription for real-time updates
  var _doneExStreamSubscription;

  @override
  void dispose() {
    // Cancel stream subscription when provider is disposed
    _doneExStreamSubscription?.cancel();
    super.dispose();
  }

  // Real-time listening method
  void listenToDoneExStream() {
    try {
      _doneExStreamSubscription = FireBaseConestFounctions.getExsIsDoneStream()
          .listen(
            (snapshot) {
              doneEx = snapshot.docs.map((doc) => doc.data()).toList();
              notifyListeners();
            },
            onError: (e) {
              debugPrint("Error listening to done exercises: $e");
            },
          );
    } catch (e) {
      debugPrint("Error setting up stream listener: $e");
    }
  }

  // Legacy method for compatibility - now calls the stream listener
  Future<void> getDoneEx() async {
    listenToDoneExStream();
  }

  Future<void> updateEx(ExModel model) async {
    try {
      await FireBaseConestFounctions.updateEx(model);
      // No need to call getDoneEx() - stream will update automatically
    } catch (e) {
      debugPrint("Error updating exercise: $e");
    }
  }

  Future<void> deleteEx(ExModel model) async {
    try {
      await FireBaseConestFounctions.deleteEx(model);
      // No need to call getDoneEx() - stream will update automatically
    } catch (e) {
      debugPrint("Error deleting exercise: $e");
    }
  }
}
