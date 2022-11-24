import 'package:flutter/material.dart';
import 'package:manejo_sql/db/db_admin.dart';
import 'package:manejo_sql/models/task_model.dart';
import 'package:manejo_sql/widget/my_form_widget.dart';


class HomePage extends StatefulWidget {


  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  Future<String> getFullName() async{
    return "Jean";
  }
// funcion para formulario (añadir tarea) nuevo widget
  showDialogForm(){
    showDialog(context: context , builder: (BuildContext context){
      return MyFormWidget();
    }).then((value) => {
      setState(() {},)
    });
  }


  deleteTask(int taskid){

    DBAdmin.db.deleteTask(taskid).then((value) => {
      if(value >0){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
        backgroundColor: Colors.grey.shade400,
        content: Row(
        children: const[
         Icon(Icons.check_circle,color: Colors.black45,),
         SizedBox(width: 10.0,),
         Text("Tarea eliminada",style: TextStyle(color: Colors.black)),
       ],
      ),
    ),
   )
     }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Tareas"),backgroundColor: Colors.black45,),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialogForm();
      },
      child: const Icon(Icons.add,color: Colors.black,),
      ),
      body: 
        FutureBuilder( 
        future: DBAdmin.db.getTasks(), //llamando a una funcion futura
        builder: ( BuildContext context, AsyncSnapshot asyncSnapshot) {
          if(asyncSnapshot.hasData){
            List<TaskModel> miTarea = asyncSnapshot.data;
            return ListView.builder(
              itemCount: miTarea.length,
              itemBuilder: (BuildContext context, int index){
                return Dismissible(
                  key: UniqueKey(),
                  confirmDismiss: (DismissDirection direction) async{
                    return true;
                  },
                  direction: DismissDirection.startToEnd,
                  background: Container(color: Colors.grey.shade400),
                  onDismissed: (DismissDirection direction){
                    deleteTask(miTarea[index].id!);
                  },
                  child: ListTile( 
                    title: Text(miTarea[index].titulo),
                    subtitle: Text(miTarea[index].description),
                    trailing: Icon(Icons.edit),
                  ),
                );
              }
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      )
        /*Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ElevatedButton(onPressed: (){
             DBAdmin.db.getTasks();
          }, child: Text("Mostrar data")),
          ElevatedButton(onPressed: (){
             DBAdmin.db.insertRawTask();
          }, child: Text("Insertar tarea nueva")),
          ElevatedButton(onPressed: (){
             DBAdmin.db.updateTask();
          }, child: Text("Actualizar data")),
          ElevatedButton(onPressed: (){
             DBAdmin.db.deleteTask();
          }, child: Text("Eliminar data")),
        ],),
        */
    );
  }
}
