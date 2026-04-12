import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:flutter/material.dart';

class ShowTab extends StatefulWidget {
  const ShowTab({super.key});

  @override
  State<ShowTab> createState() => _ShowTabState();
}

class _ShowTabState extends State<ShowTab> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
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
      ],
    );
  }
}
