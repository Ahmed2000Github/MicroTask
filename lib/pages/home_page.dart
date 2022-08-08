import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:microtask/configurations/route.dart' as route;
import 'package:microtask/configurations/theme_color_services.dart';
import 'package:microtask/models/category_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomePage extends StatelessWidget {
  ThemeColor get themeColor => GetIt.I<ThemeColor>();
  DateTime today = DateTime.now();
  List<Category> list = [
    Category(
        numberTask: 12,
        title: 'Besiness',
        description: 'description',
        numberTaskDone: 12),
    Category(
        numberTask: 22,
        title: 'sport',
        description: 'description',
        numberTaskDone: 12),
    Category(
        numberTask: 15,
        title: 'hobbies',
        description: 'description',
        numberTaskDone: 10),
  ];
  User? user;

  HomePage() {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      color: themeColor.bgColor,
      child: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 40,
                      color: themeColor.fgColor,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 40,
                      color: themeColor.secondaryColor,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  SizedBox(
                    width: width * .01,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/picture.jpg"),
                    radius: 18,
                    backgroundColor: themeColor.primaryColor,
                    child: ClipOval(
                        child: !(user?.photoURL ?? "").isEmpty
                            ? Image.network(
                                (user?.photoURL ?? ""),
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/images/picture.jpg",
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome, ${user?.displayName}",
                  style: TextStyle(
                    fontSize: 30,
                    color: themeColor.fgColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${DateFormat('EEEE M MMMM').format(today)}",
                  style: TextStyle(
                    fontSize: 20,
                    color: themeColor.fgColor,
                  ),
                ),
              ),
            ),
            Container(
              height: height - 180,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${'categories'.toUpperCase()}",
                        style: TextStyle(
                          fontSize: 30,
                          color: themeColor.fgColor,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: height * .4,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var category = list[index];
                          double percent = list[index].numberTaskDone! /
                              (list[index].numberTask ?? 0);
                          String strPercent = percent.toString();
                          if (percent == 1) {
                            strPercent = "100";
                          } else if (percent < 1 && strPercent.length >= 4) {
                            strPercent = strPercent.substring(0, 4);
                          }
                          return Container(
                            width: width * .5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: themeColor.primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${category.title?.toUpperCase()}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      CircularPercentIndicator(
                                        radius: 120.0,
                                        lineWidth: 13.0,
                                        animation: true,
                                        percent: percent,
                                        center: Text(
                                          "${strPercent}%",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                        footer: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Text(
                                            "Done tasks",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        progressColor:
                                            themeColor.secondaryColor,
                                        backgroundColor: themeColor.errorColor,
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Total: ${category.numberTask} Tasks",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 5, 5),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "${'today\'s tasks'.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 30,
                              color: themeColor.fgColor,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${'4 Tasks'.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 30,
                              color: themeColor.fgColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * .5,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final task = list[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 2,
                                shadowColor: themeColor.fgColor,
                                color: themeColor.drowerBgClor,
                                child: ListTile(
                                  selectedColor: themeColor.primaryColor,
                                  leading: IconButton(
                                    icon: (task.numberTask ?? 1) > 16
                                        ? Icon(
                                            Icons.check_circle,
                                            size: 40,
                                            color: themeColor.secondaryColor,
                                          )
                                        : Icon(
                                            Icons.circle_outlined,
                                            size: 40,
                                            color: themeColor.secondaryColor,
                                          ),
                                    onPressed: () {},
                                  ),
                                  trailing: (task.numberTask ?? 1) > 16
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            size: 40,
                                            color: themeColor.secondaryColor,
                                          ),
                                          onPressed: () {},
                                        )
                                      : null,
                                  textColor: themeColor.fgColor,
                                  title: Text(
                                    "${task.description}",
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
