import 'package:flutter/widgets.dart';
import 'package:quicknotes/helpers/drawer_navigation.dart';
import 'package:flutter/material.dart';
import 'package:quicknotes/screens/todo_screen.dart';
import 'package:quicknotes/services/todo_service.dart';
import 'package:quicknotes/models/todo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //show todo in screen : files todo_service // home_screen
  TodoService _todoService;
  List<Todo> _todoList = List<Todo>();

  @override
  void initState(){
    super.initState();
    getAllTodos();
  }

  getAllTodos()async{
    _todoService = TodoService();
    _todoList = List<Todo>();
    var todos = await _todoService.getTodos();
    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }
  //end show todo in screen : files todo_service // home_screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("El Todo"),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index){
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
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoScreen()));
      },
      child: Icon(Icons.add,),
      ),
    );
  }
}
