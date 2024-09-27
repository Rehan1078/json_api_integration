class Todos{
  final int UserId;
  final int Id;
  final String title;
  final bool IsCompleted;


  Todos({
   required this.UserId,
   required this.Id,
   required this.title,
   required this.IsCompleted
  });

  factory Todos.fromJson(Map<String,dynamic> json){
    return Todos(
        UserId: json['userId'],
        Id: json['id'],
        title: json['title'],
        IsCompleted: json['completed']);
  }

  Map<String,dynamic> toJson(){
    return {
      'userId':UserId,
      'id':Id,
      'title':title,
      'completed':IsCompleted
    };
  }


}