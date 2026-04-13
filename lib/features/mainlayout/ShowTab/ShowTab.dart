import 'package:fitness/core/resources/Acces/AllCanAcces.dart';
import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:fitness/features/AddTab/screen/Ui/AddTab.dart';
import 'package:fitness/features/Update/UpdateEx.dart';
import 'package:fitness/features/mainlayout/ShowTab/provider/ShowTabProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ShowTab extends StatefulWidget {
  const ShowTab({super.key});

  @override
  State<ShowTab> createState() => _ShowTabState();
}

class _ShowTabState extends State<ShowTab> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          Showtabprovider()..getEx(Conests.activityCategories[0]),
      builder: (context, child) {
        var provider = Provider.of<Showtabprovider>(context);
        return Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: Conests.activityCategories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 20),
                    itemBuilder: (context, index) {
                      final selected = provider.selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          provider.changeIndex(index);
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
                ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    var item = provider.ex[index];
                    return Slidable(
                      key: ValueKey(index),
                      startActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          _buildSlidableAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Updateex(model: item),
                                ),
                              );
                            },
                            isFirst: true,
                          ),
                          _buildSlidableAction(
                            icon: Icons.delete,
                            color: Colors.red,
                            onTap: () {
                              provider.deleteEx(item);
                            },
                            isLast: true,
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          _buildSlidableAction(
                            icon: Icons.edit,
                            color: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Updateex(model: item),
                                ),
                              );
                            },
                            isFirst: true,
                          ),
                          _buildSlidableAction(
                            icon: Icons.delete,
                            color: Colors.red,
                            onTap: () {
                              provider.deleteEx(item);
                            },
                            isLast: true,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.myWhite,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                                bottom: Radius.circular(16), // بس من فوق
                              ),
                              border: Border.all(color: AppColors.myBlack),
                            ),
                            child: Center(
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.myGray2,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(
                                    Conests.activityIcons[provider
                                        .selectedIndex],
                                    color: AppColors.myBlack,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.myBlue,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      "${item.category}",
                                      style: AppStyles.smallHeaders,
                                    ),
                                    Text(
                                      "time: ${item.time}           cal: ${item.cal}",
                                      style: AppStyles.chipLabelTextUnSelected,
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        item.isDone = !item.isDone;
                                        provider.updateEx(item);
                                      },
                                      child: item.isDone
                                          ? Icon(
                                              Icons.check_box_outlined,
                                              size: 25,
                                            )
                                          : Icon(
                                              Icons.check_box_outline_blank,
                                              size: 25,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },

                  separatorBuilder: (context, index) {
                    return SizedBox(height: 20);
                  },
                  itemCount: provider.ex.length,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddTab(sIndex: provider.selectedIndex),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.myWhite,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.myBlack),
                    ),
                    child: Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.myGray2,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: AppColors.myBlack,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 85),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlidableAction({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(16) : Radius.zero,
              right: isLast ? const Radius.circular(16) : Radius.zero,
            ),
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 30)),
        ),
      ),
    );
  }
}
