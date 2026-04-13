import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/core/resources/Widgets/TextFieldsWidget.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:fitness/core/resources/firebase/constantfounctions.dart';
import 'package:fitness/features/AddTab/data/ExModel/ExModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTab extends StatefulWidget {
  int sIndex;
  AddTab({super.key, required this.sIndex});

  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  var selectedDate = DateTime.now();

  TextEditingController duration = TextEditingController();
  TextEditingController cal = TextEditingController();

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.sIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite,
      appBar: AppBar(
        backgroundColor: AppColors.myBlue,
        title: Text("ADD New Practice", style: AppStyles.appBarText),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Select practice type", style: AppStyles.smallHeaders),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
              child: SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: Conests.activityCategories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                  itemBuilder: (context, index) {
                    final selected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        selectedIndex = index;
                        setState(() {});
                      },
                      child: Chip(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: selected
                            ? AppColors.myBlue
                            : AppColors.myWhite,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Conests.activityIcons[index],
                              size: 18,
                              color: selected
                                  ? AppColors.myWhite
                                  : AppColors.myBlack,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Conests.activityCategories[index],
                              style: selected
                                  ? AppStyles.chipLabelTextSelected
                                  : AppStyles.chipLabelTextUnSelected,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Text("Duration(MINUTES)", style: AppStyles.smallHeaders),
            TextFieldsWidget(
              hint: 'Time',
              controller: duration,
              suffixIcon: Icon(Icons.timer, color: AppColors.myGray1, size: 25),
            ),
            SizedBox(height: 10),
            Text("Calories Burned", style: AppStyles.smallHeaders),
            TextFieldsWidget(
              hint: 'Calories',
              controller: cal,
              suffixIcon: Icon(
                CupertinoIcons.flame,
                color: AppColors.myGray1,
                size: 25,
              ),
            ),
            SizedBox(height: 10),
            Text("Date", style: AppStyles.smallHeaders),
            GestureDetector(
              onTap: () {
                ChoseDate();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.myWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.myBlack, width: 2),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        selectedDate.toString().substring(0, 10),
                        style: AppStyles.smallHeaders,
                      ),
                      ImageIcon(
                        AssetImage("assets/images/calendar-add.png"),
                        size: 25,
                        color: AppColors.myGray1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            MaterialButton(
              onPressed: () {
                ExModel model = ExModel(
                  category: Conests.activityCategories[selectedIndex],
                  time: duration.text,
                  cal: cal.text,
                  // ✅ FIX: use millisecondsSinceEpoch to match Firestore queries
                  // The old code used microsecondsSinceEpoch which is 1000x larger
                  // causing all documents to fall outside the query date range
                  date: selectedDate.millisecondsSinceEpoch,
                );
                FireBaseConestFounctions.cerateEx(model);
                Navigator.pop(context);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(16),
              ),
              color: AppColors.myBlue,
              minWidth: double.infinity,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 15),
                child: Text("Save Activity", style: AppStyles.bottomText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ChoseDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }
}
