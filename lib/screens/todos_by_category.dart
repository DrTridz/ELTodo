import 'package:flutter/material.dart';
import 'package:quicknotes/models/Todo.dart';
import 'package:quicknotes/services/todo_service.dart';

class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({this.category});
  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  //lecture 84 (84. Show category based todo on drawer navigation item press)
  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  getTodosByCategory()async{
   var todos = await _todoService.todosByCategory(this.widget.category);
   todos.forEach((todo){
     setState(() {
       var model = Todo();
       model.title = todo['title'];
       model.description = todo ['description'];
       model.todoDate = todo ['todoDate'];
       _todoList.add(model);
     });
   });
  }

  //lecture 84 (84. Show category based todo on drawer navigation item press)
  @override
  void initState(){
    super.initState();
    getTodosByCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos By Category"),
      ),
      body:  Column(
        children: <Widget>[
          Text('Cat Name: ${this.widget.category}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
          Expanded(child: ListView.builder(itemCount: _todoList.length,itemBuilder:(context, index){
            return Card(
              child: Column(
                children: <Widget>[
                  Text('Date: ${_todoList[index].todoDate}' ?? 'No Date'),
                Container(
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Title: ${_todoList[index].title }'?? 'No Date'),
                    ],

                  ),
                  subtitle: Text('Description: ${_todoList[index].description}' ?? 'No Date'),
                ),
                ),
                ],
              ),
            );

          } ),),
        ],
      ),
    );
  }
}
