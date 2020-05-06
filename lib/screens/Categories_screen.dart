import 'package:quicknotes/models/category.dart';
import 'package:quicknotes/screens/home_screen.dart';
import 'package:quicknotes/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryName = TextEditingController();
  var _categoryDescription = TextEditingController();

  var _category = Category();
  var _categoryService = CategoryService();

  List<Category> _categoryList = List<Category>();

  var _editCategoryName = TextEditingController();

  var _editCategoryDescription = TextEditingController();

  var category;

  @override
  void initState(){
    super.initState();
    getAllCategories();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  getAllCategories()async{
    _categoryList = List<Category>();
    var categories = await _categoryService.getCategories();
    categories.forEach((category){
      setState(() {
        var model = Category();
        model.name = category['name'];
        model.id = category['id'];
        model.description = category['description'];
        _categoryList.add(model);
      });
    });
  }

  _showFormInDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel")),
              FlatButton(
                  onPressed: () async{
                    _category.name = _categoryName.text;
                    _category.description = _categoryDescription.text;
                    var result = await _categoryService.saveCategory(_category);
                    if(result > 0){
                      Navigator.pop(context);
                    }
                    print(result);
                  },
                  child: Text("Save")),
            ],
            title: Text("Category Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryName,
                    decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'Write Category Name here'),
                  ),
                  TextField(
                    controller: _categoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Category Description',
                        hintText: 'Write Category Description here'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editCategoryDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("Cancel")),
              FlatButton(
                  onPressed: () async{
                    _category.id = category[0]['id'];
                    _category.name = _editCategoryName.text;
                    _category.description = _editCategoryDescription.text;
                    var result = await _categoryService.updateCategory(_category);
                    if(result > 0 ){
                      Navigator.pop(context);
                      getAllCategories();
                      _showSnakBar(Text("Seccess"));
                    }
                    print(result);
                  },
                  child: Text("Update")),
            ],
            title: Text("Category Edit Form"),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryName,
                    decoration: InputDecoration(
                        labelText: 'Category Name',
                        hintText: 'Write Category Name here'),
                  ),
                  TextField(
                    controller: _editCategoryDescription,
                    decoration: InputDecoration(
                        labelText: 'Category Description',
                        hintText: 'Write Category Description here'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //Delete Category

  _deleteCategoryDialog(BuildContext context,categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(onPressed: () {
                Navigator.pop(context);
              }, child: Text("No")),
              FlatButton(
                  onPressed: ()async{
                  var result =  await _categoryService.deleteCategory(categoryId);
                   if(result > 0 ){
                     Navigator.pop(context);
                     getAllCategories();
                     _showSnakBar(Text("Seccess"));
                   }
                   print(result);
                  },
                  child: Text("Yes")),
            ],
            title: Text("Are you Shur "),
            content: Text("you want delete this Category "),
          );
        });
  }

  //Delete Category

  _editCategory(BuildContext context, categoryId)async{
   category = await _categoryService.getCategoryById(categoryId);
   setState(() {
     _editCategoryName.text = category[0]['name'] ?? 'No Name';
     _editCategoryDescription.text = category[0]['description']?? 'No Description';
   });
   _editCategoryDialog(context);
  }

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
        title: Text("Category Form"),
        leading: RaisedButton(
            elevation: 0.0,
            color: Colors.red,
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
      ),
      body: ListView.builder(itemCount: _categoryList.length, itemBuilder: (context, index){
        return //Start Card
          Card(child:ListTile(
            leading: IconButton(icon: Icon(Icons.edit), onPressed: (){
              _editCategory(context, _categoryList[index].id);
            }),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_categoryList[index].name),
                IconButton(icon: Icon(Icons.delete), onPressed: (){
                  _deleteCategoryDialog(context, _categoryList[index].id);
                })
              ],
            ),),);
//End Card
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormInDialog(context);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
