import 'package:quicknotes/screens/Categories_screen.dart';
import 'package:quicknotes/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:quicknotes/screens/todos_by_category.dart';
import 'package:quicknotes/services/category_service.dart';

class DrawerNavigation extends StatefulWidget {
  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  //Show Category in drawer navigation
  List<Widget> _categoryList = List<Widget>();
  CategoryService _categoryService = CategoryService();

  @override
  void initState(){
    super.initState();
    getAllCategories();
  }
  getAllCategories()async{
    var categories = await _categoryService.getCategories();
    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TodosByCategory(category: category['name'],)));
        },child: ListTile(title: Text(category['name']),)));
      });
    });
  }
  //End Show Category in drawer navigation
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("El Todo"),
              accountEmail: Text("Category & Priority Todo App"),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
              },
            ),
            ListTile(
              title: Text("Category"),
              leading: Icon(Icons.view_list),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoriesScreen()));
              },
            ),
            Divider(),
            Column(children: _categoryList,),
          ],
        ),
      ),
    );
  }
}
