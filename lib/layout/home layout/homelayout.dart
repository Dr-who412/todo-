import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todolsit/modules/cubit/cubit.dart';
import 'package:todolsit/modules/cubit/states.dart';

class homelayput extends StatelessWidget {
  var scaffoldGkay = GlobalKey<ScaffoldState>();
  var formkay = GlobalKey<FormState>();
  var faldContraller = TextEditingController();
  var timeContraller = TextEditingController();
  var dateContraller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {
        if (state is AppInsertDBState) {
          Navigator.pop(context);
        }
      }, builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldGkay,
          appBar: AppBar(
            title: Text(
              "${cubit.titles[cubit.currentIndex]}",
            ),
            centerTitle: true,
            backgroundColor: Colors.greenAccent.withAlpha(190),
            titleTextStyle: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isbottomsheetState) {
                if (formkay.currentState!.validate()) {
                  cubit.insertToDb(
                    title: faldContraller.text,
                    date: dateContraller.text,
                    time: timeContraller.text,
                  );
                }
              } else {
                scaffoldGkay.currentState!
                    .showBottomSheet(
                        (context) => Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(20.0),
                              child: Form(
                                key: formkay,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      controller: faldContraller,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'title must not be Empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        focusColor:
                                            Colors.greenAccent.withAlpha(190),
                                        label: Text("Title"),
                                        prefixIcon: Icon(Icons.title),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    TextFormField(
                                      controller: timeContraller,
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'time must not be Empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text("Task Time"),
                                        prefixIcon:
                                            Icon(Icons.watch_later_outlined),
                                      ),
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeContraller.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    TextFormField(
                                      controller: dateContraller,
                                      keyboardType: TextInputType.datetime,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'date must not be Empty';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        label: Text("Task Date"),
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                      onTap: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.parse(
                                                    '2030-05-01'))
                                            .then((value) {
                                          dateContraller.text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        elevation: 20.0)
                    .closed
                    .then((value) {
                  cubit.changeIcon(isShow: false, icon: Icons.edit);
                });
                cubit.changeIcon(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
            elevation: 8.0,
            backgroundColor: Colors.greenAccent.withAlpha(190),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.greenAccent.withAlpha(190),
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            elevation: 20.0,
            onTap: (index) {
              cubit.changeScreen(index);
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu), label: "new tasks"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'done tasks'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'archive'),
            ],
          ),
          body: ConditionalBuilder(
            condition: true,
            builder: (context) => cubit.screens[cubit.currentIndex],
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }),
    );
  }
}
