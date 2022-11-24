import 'package:flutter/material.dart';
import 'package:manejo_sql/models/task_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class DBAdmin {
  Database? myDatabase;
  static final DBAdmin db = DBAdmin._();
  DBAdmin._();


 Future<Database?> checkDataBase() async{
    if(myDatabase != null){
      return myDatabase;
    }
    myDatabase = await initDatabase();
    return myDatabase;
  }

  Future<Database> initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "TaskDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database dbx,int version) async{
        //crear la tabla de la base de datos
        await dbx.execute('CREATE TABLE Task(id INTEGER PRIMARY KEY, titulo TEXT, description TEXT,status TEXT)');
      }
    );
  }
  //insercion cruda (sql)
  Future <int>insertRawTask(String titulo, String description, bool status) async { // añadiendo parametros
   Database? db = await checkDataBase();
   int res = await db!.rawInsert("INSERT INTO Task(titulo,description,status) VALUES ('$titulo','$description','$status')");
    return res;
  }
  // 2da opcion para insertar
  Future <int>insertTask(TaskModel model)async{
    Database? db = await checkDataBase();
    int res = await db!.insert("Task"
    ,{
      "titulo": model.titulo,
      "description":model.description,
      "status":model.status.toString(),
    }
    );
    //imprimimos en consola
    return res;
  }
  // -------------- metodos para obtener los datos en pantalla app movil
  //sentencia dura (escribimos toda la estructura sql)
  getRawTasks() async{
    Database? db = await checkDataBase();
    List tasks = await db!.rawQuery("SELECT * FROM Task");
    print(tasks);
  }

  // metodo para obtener los datos (resumida)
  //funcion future

  Future<List<TaskModel>>getTasks() async{
    Database? db = await checkDataBase();
    List<Map<String, dynamic>> tasks = await db!.query("Task");
    List<TaskModel> taskModelList = tasks.map((e) => TaskModel.deMapAModel(e)).toList();
      /*  tasks.forEach((element) {
          TaskModel task = TaskModel.deMapAModel(element);
          taskModelList.add(task);
        });
      */  
    return taskModelList;
  }



  //insercion cruda para actualizar
  updateRawTask() async{
    Database? db = await checkDataBase();
    int res = await db!.rawUpdate("UPDATE TASK SET titulo='Ir de compras', description='comprar whiskas para el gato',status='true' WHERE id=2");
    print(res);  
  }
  Future<int> updateTask(TaskModel taskModel) async {
    Database? db = await checkDataBase();
    int res = await db!.update(
      "TASK",
      {
        "title": taskModel.titulo,
        "description": taskModel.description,
        "status" : taskModel.status
      },
      where: "id = ${taskModel.id}"
    );
    return res;
  }

  deleteRawtask() async{
    Database? db = await checkDataBase();
    int res = await db!.rawDelete("DELETE FROM Task WHERE id = 2");
    print(res);
  }
  //modificando la funcion delete para tomar solamente por ID
  Future <int> deleteTask(int id) async{
    Database? db = await checkDataBase();
    int res = await db!.delete("Task", where: "id = $id");
    return res;
  }

}