import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todolsit/modules/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required validate,
  required String label,
  required IconData prefix,
  onChange,
  onsubmit,
  onTap,
  bool isPassword = true,
  IconData? suffix,
  Function? suffixPressed,
})=>TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onsubmit,
  onChanged: onChange,
  onTap: onTap,
  validator: validate,
  decoration:  InputDecoration(
     label: Text(label),
    prefixIcon: Icon(prefix),
    suffixIcon: Icon(suffix),
    suffix: IconButton(onPressed: (){suffixPressed;}, icon: Icon(suffix)),
  ),

);

Widget buildTaskItem({
  context,
   required Map model,
}
)=>Padding(
padding: const EdgeInsets.all(1.0),
child: Dismissible(
  background: model['status']!='archived'? Icon(Icons.archive): Icon(Icons.delete),
  secondaryBackground:  Icon(Icons.delete) ,
  movementDuration: Duration(seconds: 2),
  resizeDuration: Duration(seconds: 2),
  key: Key("${model['id']}"),
  onDismissed: (direction){
    if(direction==DismissDirection.startToEnd && model['status']!='archived'){
       AppCubit.get(context).UpdateDate(id: model['id'], status: 'archived');
    }else{
      AppCubit.get(context).deleteDate(id: model['id']);
    }
    print(direction);
  },
  child:   Card(
  
    shadowColor:Colors.greenAccent,
  
    elevation: 2.0,
  
    color: Colors.white54,
  
    child:   Padding(
  
      padding: EdgeInsets.all(8.0),
  
      child: Row(
  
        children: [
  
  
  
      CircleAvatar(child: Text("${model['time']}"),radius: 40.0,backgroundColor: Colors.white60,foregroundColor: Colors.black),
  
  
  
      SizedBox(width: 10,),
  
  
  
      Expanded(
  
        child: Column(
  
  
  
        mainAxisSize: MainAxisSize.min,
  
  
  
        children: [
  
  
  
        Text("${model['title']}", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
  
  
  
        SizedBox(width: 5,),
  
  
  
        Text("${model['date']}", style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),),
  
  
  
        ],
  
  
  
        ),
  
      ),
  
        SizedBox(width: 20,),
  
        IconButton(onPressed: (){
  
         model['done']=='done' ? AppCubit.get(context).UpdateDate(id: model['id'], status: 'new'):AppCubit.get(context).UpdateDate(id: model['id'], status: 'done');
  
          print(model['status']);
  
        }, icon: Icon(Icons.check_circle ,color: model['status']=='done'?Colors.greenAccent.withAlpha(190):Colors.white,size: 28,)),
  
      ],),
  
    ),
  
  ),
),
);
Widget ConditionList(List<Map> tasks){
  return ConditionalBuilder(
      condition: tasks.length>0,
      builder: (context) => ListView.builder(itemBuilder: (context,int i){
        return buildTaskItem(context:context,model:tasks[i]);},
          itemCount:tasks.length),

      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.menu,color: Colors.grey,size: 100.0,),
            Text("No Tasks yet",style: TextStyle(fontSize: 16.0,color:Colors.grey,fontWeight: FontWeight.bold),)
          ],
        ),
      ));
}