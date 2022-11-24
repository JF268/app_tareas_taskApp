class TaskModel {
  int? id;
  String titulo;
  String description;
  String status;

  TaskModel(
      {this.id,
      required this.titulo,
      required this.description,
      required this.status});
 //constructor con nombre
   factory TaskModel.deMapAModel(Map<String, dynamic> mapa) => TaskModel(
      id: mapa["id"], 
      titulo: mapa["titulo"], 
      description: mapa["description"], 
      status: mapa["status"]);
}
