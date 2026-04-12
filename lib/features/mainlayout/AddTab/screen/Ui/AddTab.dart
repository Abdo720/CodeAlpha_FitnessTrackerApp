import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/core/resources/Widgets/TextFieldsWidget.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTab extends StatefulWidget {
  AddTab({super.key});

  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  TextEditingController duration = TextEditingController();
  TextEditingController cal = TextEditingController();

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          SizedBox(height: 20),
          Text("ADD New Practice", style: AppStyles.headers),
          SizedBox(height: 20),
          Text("Select practice type", style: AppStyles.smallHeaders),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 0),
            child: SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: Conests.activityCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
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
        ],
      ),
    );
  }
}
