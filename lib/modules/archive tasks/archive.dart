import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/componant/componant.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class archive extends StatelessWidget {
  const archive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          var tasks=AppCubit.get(context).archivedTasks;
          return ConditionList(tasks); }
    );
  }
}
