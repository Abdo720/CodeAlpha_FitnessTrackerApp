import 'package:fitness/core/resources/Acces/AllCanAcces.dart';
import 'package:fitness/core/resources/AppColors/AppColors.dart';
import 'package:fitness/core/resources/AppStyles/AppStyles.dart';
import 'package:fitness/features/AddTab/screen/Ui/AddTab.dart';
import 'package:fitness/features/mainlayout/Progress/progress.dart';
import 'package:fitness/features/mainlayout/ShowDoneTab/ShowDoneTab.dart';
import 'package:fitness/features/mainlayout/ShowTab/ShowTab.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> pages = [ShowTab(), ShowDoneTab(), Progress()];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.myWhite,
      appBar: AppBar(
        backgroundColor: AppColors.myBlue,
        foregroundColor: AppColors.myWhite,
        title: Text("Welcome back", style: AppStyles.appBarText),
      ),
      extendBody: true,
      body: pages[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.myBlue,
          currentIndex: index,
          onTap: (val) {
            setState(() {
              index = val;
            });
          },
          selectedItemColor: AppColors.myWhite,
          unselectedItemColor: AppColors.myGray1,
          selectedIconTheme: IconThemeData(size: 35),
          iconSize: 20,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_outline_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_sharp),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
