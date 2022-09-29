import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoModel {
  String name;
  int dateTime;
  bool isChecked;

  TodoModel(this.name, this.dateTime, this.isChecked);
}

class TodoProvider extends ChangeNotifier {
  List<TodoModel> listTodos = [];
  SharedPreferences? sharedPreferences;


  void createNewTodo(String name) async{
    if(name != ''){
      int dateTime = DateTime.now().millisecondsSinceEpoch;
      TodoModel model = TodoModel(name, dateTime, false);
      listTodos.add(model);
      await saveDataFromLocal();
      notifyListeners();
    }
  }

  void onRemove() async{
    listTodos.removeWhere((element) => element.isChecked == true);
    await saveDataFromLocal();
    notifyListeners();
  }

  void onTap(TodoModel model){
    if(model.isChecked == false) {
      model.isChecked = true;
      notifyListeners();
    }
    else model.isChecked = false;
    notifyListeners();
  }

  Future saveDataFromLocal() async{
    if(sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }
    List<String> listDataString = [];
    for(TodoModel model in listTodos){
      Map<String,dynamic> dataJson = Map<String,dynamic>();

      dataJson['name'] = model.name;
      dataJson['dateTime'] = model.dateTime;
      dataJson['isChecked'] = model.isChecked;

      String dataString = jsonEncode(dataJson);
      listDataString.add(dataString);
    }
    await sharedPreferences!.setStringList('saveDataToLocal', listDataString);
  }

  void getDataFromLocal() async{
    if(sharedPreferences == null){
      sharedPreferences = await SharedPreferences.getInstance();
    }
    // await Future.delayed(Duration(seconds: 1));
    List<String>? listStringLocal = sharedPreferences!.getStringList('saveDataToLocal');
    if(listStringLocal != null && listStringLocal.isNotEmpty){
      for(String data in listStringLocal){
        Map<String,dynamic> dataJson = jsonDecode(data);
        TodoModel model = TodoModel(dataJson['name'], dataJson['dateTime'], dataJson['isChecked']);

        listTodos.add(model);
      }
    }
    notifyListeners();
  }

}