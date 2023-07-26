import 'package:api_randomuser_crud/screens/add_page.dart';
import 'package:flutter/material.dart';
import '../service.dart/todo_service.dart';
import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //for items
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Todo List")),
      ),

      //body
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No Todo Item",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            child: ListView.builder(
                padding: const EdgeInsets.all(7),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text("${index + 1}"),
                      ),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(onSelected: (value) {
                        if (value == 'edit') {
                          //Open Edit Page
                          navigateToEditPage(item);
                        } else if (value == 'delete') {
                          //Delete and remove the item

                          //DELETE API
                          deleteById(id);
                        }
                      }, itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text("Delete"),
                          ),
                        ];
                      }),
                    ),
                  );
                }),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: navigateToAddPage, label: const Text('Add Todo')),
    );
  }

  //Edit Page

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Add Page
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //Api Get All
  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    // String url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    // final uri =Uri.parse(url);
    // final response = await http.get(uri);
    if (response != null) {
      // final json = jsonDecode(response.body) as Map;
      // final result = json['items'] as List;

      setState(() {
        items = response;
      });
    }else{
      // ignore: use_build_context_synchronously
      showErrorMessage(context,message: "Something went wrong");
    }
    setState(() {
      isLoading = false;
    });
    // print(response.statusCode);
    // print(response.body);
  }

  //For delete
  Future<void> deleteById(String id) async {
    //Delete the item
    // String url = 'https://api.nstack.in/v1/todos/$id';
    // final  uri =Uri.parse(url);
    // final response = await http.delete(uri);

    final isSuccess = await TodoService.deleteById(id);

    if (isSuccess) {
      //Remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();

      setState(() {
        items = filtered;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context,message: "Deletion Failed !");
    }
    //Remove item from the list
  }

 
}
