class ToDoList{
  final String id;
  final String name;
  final DateTime date;
  ToDoList({
    required this.date, required this.id, required this.name
  });

  factory ToDoList.fromJson(Map<String, dynamic>json){
    return ToDoList(id : json['id'],
    name : json['name'],
    date : DateTime.parse(json['date']));
  }
}