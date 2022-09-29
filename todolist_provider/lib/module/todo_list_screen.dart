import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist_provider/module/todo_list_provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<TodoProvider>().getDataFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TodoList',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                context.read<TodoProvider>().createNewTodo(_controller.text);
                _controller.text = '';
              }
          ),
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: (){
              context.read<TodoProvider>().onRemove();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: 'Nhập việc bạn cần làm !'),
              ),
            ),
            Expanded(
              child: Consumer(
                builder: (_, TodoProvider todoProvider, __){
                  if(todoProvider.listTodos.isNotEmpty){
                    todoProvider.listTodos.sort(
                        (a,b) => (b.dateTime).compareTo(a.dateTime)
                    );
                    return ListView.builder(
                        itemCount: todoProvider.listTodos.length,
                        itemBuilder: (context, index){
                          return itemWidget(todoProvider.listTodos[index], todoProvider);
                        }
                    );
                  }
                  return Center(
                    child: Text('Chưa có dữ liệu'),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget itemWidget(TodoModel model, TodoProvider todoProvider){
    return InkWell(
      onTap: (){
        todoProvider.onTap(model);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: model.isChecked == false ? Colors.grey : Colors.green,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(model.name),
            Text(DateTime.fromMillisecondsSinceEpoch(model.dateTime).toString()),
          ],
        ),
      ),
    );
  }
}
