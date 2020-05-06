import 'package:flutter/material.dart';
import 'package:quicknotes/models/todo.dart';
import 'package:quicknotes/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:quicknotes/services/todo_service.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  //========= Start My Controller ========\\
  var _qNoteTitle = TextEditingController();

  var _qNoteDescription = TextEditingController();

  var _qNoteDate = TextEditingController();

  var _categories = List<DropdownMenuItem>();

  var _selectedValue;

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _loadCategories()async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.getCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(child: Text(category['name']), value:  category['name'],));
      });
    });
  }



  DateTime _date = DateTime.now();
  _selectQNoteDate(BuildContext context)async{
   var _pickedDate = await showDatePicker(context: context, initialDate: _date, firstDate:DateTime (2000), lastDate:DateTime(2099));
   if(_pickedDate != null){
     setState(() {
       _date = _pickedDate;
       _qNoteDate.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
     });
   }
  }



 // ========= End  My controller ==========\\

  _showSnakBar(message){
    var _snakBar = SnackBar(
      content: message,
    );
    _scaffoldKey.currentState.showSnackBar(_snakBar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Crate QNote"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _qNoteTitle,
            decoration: InputDecoration(
              hintText: 'QNote Title',
              labelText: 'Cook Food',
            ),
          ),
          TextField(
            controller: _qNoteDescription,
            decoration: InputDecoration(
              hintText: 'QNnot Description',
              labelText: 'Cook Rice and curry',
            ),
          ),
          TextField(
            controller: _qNoteDate,
            decoration: InputDecoration(
              hintText: 'YY-MM-DD',
              labelText: 'YY-MM-DD',
              prefixIcon: InkWell(onTap: (){
                _selectQNoteDate(context);
              },
                  child: Icon (Icons.calendar_today)),
            ),
          ),
          DropdownButtonFormField(
            value: _selectedValue,
            items: _categories,
            hint: Text("Select one Category") ,
            onChanged: (value){
              setState(() {
                _selectedValue = value;
              });
            },
          ),

          RaisedButton(onPressed: ()async{
            var todoObj = Todo();
            todoObj.title = _qNoteTitle.text;
            todoObj.description = _qNoteDescription.text;
            todoObj.todoDate = _qNoteDate.text;
            todoObj.category = _selectedValue;
            todoObj.isFinished = 0;
            var _todoService = TodoService();
            var result = await _todoService.insertTodo(todoObj);
            if(result > 0 ){
              _showSnakBar(Text('Seccess'));
            }
          },
          child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
