import 'package:database/shared/componand/sharing.dart';
import 'package:database/shared/cubit/cubit.dart';
import 'package:database/shared/cubit/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewDone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder:(context,state){
        var tasks =AppCubit.get(context).doneTasks;

        return ListView.separated(
            itemBuilder: (context, index) => buildPadding(tasks[index],context),
            separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[400],
            ),
            itemCount: tasks.length) ;
      },

    );
  }
}
