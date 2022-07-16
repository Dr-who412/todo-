import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolsit/modules/cubit/cubit.dart';
import 'package:todolsit/modules/cubit/states.dart';
import '../../shared/componant/constance.dart';
import '../../shared/componant/componant.dart';
class newtasks extends StatelessWidget {
  const newtasks({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        var tasks=AppCubit.get(context).newTasks;
       return ConditionList(tasks);
      }
    );
   }
}
