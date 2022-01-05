import 'package:database/shared/cubit/cubit.dart';
import 'package:database/shared/cubit/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class HomeLeyout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dataController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.current]),
            ),
            body: state is! AppGetDatabaseLoadingState?  cubit.screen[cubit.current] :Center(child: CircularProgressIndicator()),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isButtonsheetOpen) {
                  if (formKey.currentState!.validate()) {

                    cubit.insertDataBase(title: titleController.text, time: timeController.text, data: dataController.text);
                    // insertDataBase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   data: dataController.text,
                    // ).then((value) {
                    //   getDataFromDataBase(database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isButtonsheetOpen = false;
                    //     //   fabIcon = Icons.edit;
                    //     //   tasks =value ;
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white70,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextFormField(
                                    Icon(Icons.title),
                                    "Title",
                                    TextInputType.name,
                                    () {
                                      return null;
                                    },
                                    titleController,
                                    (value) {
                                      if (value.isEmpty) {
                                        return 'Title Is Empty';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                buildTextFormField(
                                    Icon(Icons.access_time),
                                    'Time',
                                    TextInputType.datetime,
                                    () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    timeController,
                                    (value) {
                                      if (value.isEmpty) {
                                        return 'Time Is Empty';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 15,
                                ),
                                buildTextFormField(
                                    Icon(Icons.calendar_today),
                                    'Data',
                                    TextInputType.datetime,
                                    () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse("2022-10-27"),
                                      ).then((value) {
                                        dataController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    dataController,
                                    (value) {
                                      if (value.isEmpty) {
                                        return 'Data Is Empty';
                                      }
                                      return null;
                                    }),

                                // buildTextFormField(icon, lableTex, type)
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottonSheetState(isShow: false, icon: Icons.edit);


                  });
                  cubit.changeBottonSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.current,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'tasks',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archived'),

              ],
            ),
          );
        },
      ),
    );
  }

  TextFormField buildTextFormField(
    Icon icon,
    String lableTex,
    TextInputType type,
    GestureTapCallback ontap,
    TextEditingController controller,
    FormFieldValidator validat,
  ) {
    return TextFormField(
      validator: validat,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: icon,
        labelText: lableTex,
      ),
      keyboardType: type,
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      onTap: ontap,
    );
  }


}
