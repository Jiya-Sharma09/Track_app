class Todo{
  final String id ; 
  final String title;
  final String description = "";
  final DateTime dueDate;
  bool isDone;
 Todo({required this.id, 
 required this.title, required this.dueDate, required this.isDone});

 factory Todo.fromJson(Map<String, dynamic>json){
  return Todo(id: json['id'], title: json['title'], dueDate: DateTime.parse(json['dueDate']), isDone: json['Completed']);
 }
}