import 'package:quicknotes/models/todo.dart';
import 'package:quicknotes/repositories/repository.dart';

class TodoService{
  Repository _repository;
  TodoService(){
    _repository = Repository();
  }
  //insert todo to datebase
  insertTodo(Todo todo)async{
    return await _repository.save('todos', todo.todoMap());
  }
//show todo in screen : files todo_service // home_screen
  getTodos()async{
    return await _repository.getAll('todos');
  }

  todosByCategory(String category) async{
   return await _repository.getByColumnName('todos', 'category', category);
  }
}