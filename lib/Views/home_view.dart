// ignore_for_file: must_be_immutable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todo_app/Views/task_view.dart';
import '../../main.dart';
import '../Models/task.dart';
import '../Utils/constants.dart';
import '../Utils/theme.dart';
import 'Widgets/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> dKey = GlobalKey<SliderDrawerState>();

  ///? Checking Completed Tasks
  int checkingCompletedTasks(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  ///? Checking The Value Of the Circle Indicator
  dynamic indicatorValue(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final base = BaseWidget.of(context);
    var textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder(
        valueListenable: base.dataStore.listenToTask(),
        builder: (context, Box<Task> box, Widget? child) {
          var tasks = box.values.toList();

          /// Sort Task List
          tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));

          return Scaffold(
            backgroundColor: Colors.white,

            ///* Floating Action Button
            floatingActionButton: const FAB(),

            ///* Body
            body: SliderDrawer(
              isDraggable: false,
              key: dKey,
              animationDuration: 1000,

              ///*  AppBar
              appBar: MyAppBar(
                drawerKey: dKey,
              ),

              //*/ My Drawer Slider
              slider: MySlider(),

              ///* Main Body
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/todo.png',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                  ),
                ),
                child: _buildMainBody(
                  tasks,
                  base,
                  textTheme,
                ),
              ),
            ),
          );
        });
  }

  ///? Main Body
  SizedBox _buildMainBody(
    List<Task> tasks,
    BaseWidget base,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
              width: double.infinity,
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///? CircularProgressIndicator
                  SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      valueColor:
                          const AlwaysStoppedAnimation(MyColors.primaryColor),
                      backgroundColor: Colors.grey,
                      value:
                          checkingCompletedTasks(tasks) / indicatorValue(tasks),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),

                  /// Texts
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(MyString.mainTitle, style: textTheme.displayLarge),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                          "${checkingCompletedTasks(tasks)} of ${tasks.length} tasks",
                          style: textTheme.titleMedium),
                    ],
                  )
                ],
              ),
            ),

            ///? Divider
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Divider(
                thickness: 2,
                indent: 20,
                endIndent: 20,
                color: MyColors.primaryColor,
              ),
            ),

            ///? Bottom ListView : Tasks
            SizedBox(
              width: double.infinity,
              height: 300,
              child: tasks.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        var task = tasks[index];

                        return Dismissible(
                          direction: DismissDirection.horizontal,
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(MyString.deletedTask,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                          onDismissed: (direction) {
                            base.dataStore.dalateTask(task: task);
                          },
                          key: Key(task.id),
                          child: TaskWidget(
                            task: tasks[index],
                          ),
                        );
                      },
                    )

                  /// if All Tasks Done Show this Widgets
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Lottie
                        FadeIn(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Lottie.asset(
                              lottieURL,
                              animate: tasks.isNotEmpty ? false : true,
                            ),
                          ),
                        ),

                        /// Bottom Texts
                        FadeInUp(
                          from: 30,
                          child: const Text(MyString.doneAllTask),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}

///? My Drawer Slider
class MySlider extends StatelessWidget {
  MySlider({
    Key? key,
  }) : super(key: key);

  List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: MyColors.primaryGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/girly.jpg'),
          ),
          const SizedBox(
            height: 8,
          ),
          Text("Areeba Farooq", style: textTheme.displayMedium),
          Text("Flutter Developer", style: textTheme.displaySmall),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 10,
            ),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: icons.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return InkWell(
                    // ignore: avoid_print
                    onTap: () => print("$i Selected"),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                          leading: Icon(
                            icons[i],
                            color: Colors.white,
                            size: 30,
                          ),
                          title: Text(
                            texts[i],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}

///? My App Bar
class MyAppBar extends StatefulWidget with PreferredSizeWidget {
  MyAppBar({
    Key? key,
    required this.drawerKey,
  }) : super(key: key);
  GlobalKey<SliderDrawerState> drawerKey;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _MyAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ///? toggle for drawer and icon aniamtion
  void toggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        controller.forward();
        widget.drawerKey.currentState!.openSlider();
      } else {
        controller.reverse();
        widget.drawerKey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 132,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: controller,
                    size: 30,
                  ),
                  onPressed: toggle),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  base.isEmpty
                      ? warningNoTask(context)
                      : deleteAllTask(context);
                },
                child: const Icon(
                  CupertinoIcons.trash,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///? Floating Action Button
class FAB extends StatelessWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => TaskView(
              taskControllerForSubtitle: null,
              taskControllerForTitle: null,
              task: null,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
        elevation: 10,
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: MyColors.primaryColor,
          ),
          child: const Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ),
      ),
    );
  }
}
