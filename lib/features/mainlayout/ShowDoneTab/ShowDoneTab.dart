import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:fitness/features/Update/UpdateEx.dart';
import 'package:fitness/features/mainlayout/ShowDoneTab/provider/ShowDoneProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ShowDoneTab extends StatelessWidget {
  const ShowDoneTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Showdoneprovider()..getDoneEx(),
      builder: (context, child) {
        var provider = Provider.of<Showdoneprovider>(context);

        return provider.doneEx.isEmpty
            ? Center(
                child: Text("No Done Ex Founded", style: AppStyles.headers),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                itemCount: provider.doneEx.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  var item = provider.doneEx[index];

                  int index2 = Conests.activityCategories.indexOf(
                    item.category,
                  );

                  return Slidable(
                    key: ValueKey(item.id),

                    /// 👉 سحب يمين
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

                    /// 👉 سحب شمال
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
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                              bottom: Radius.circular(16),
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
                                  index2 != -1
                                      ? Conests.activityIcons[index2]
                                      : Icons.error,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.category,
                                    style: AppStyles.smallHeaders,
                                  ),
                                  Text(
                                    "time: ${item.time}   cal: ${item.cal}",
                                    style: AppStyles.chipLabelTextUnSelected,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      item.isDone = !item.isDone;
                                      provider.updateEx(item);
                                    },
                                    child: item.isDone
                                        ? const Icon(
                                            Icons.check_box_outlined,
                                            size: 25,
                                          )
                                        : const Icon(
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
              );
      },
    );
  }
}

/// 🔥 شكل الأزرار (Edit / Delete)
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
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 30, // 🔥 أكبر شوية
          ),
        ),
      ),
    ),
  );
}
