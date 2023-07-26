import 'package:api_randomuser_crud/service.dart/todo_service.dart';
import 'package:flutter/material.dart';
import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    final todo = widget.todo;
    super.initState();
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(isEdit ? "Edit Todo" : "Add Todo")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'))
        ],
      ),
    );
  }

  //for update button
  Future<void> updateData() async {
    //Get the data from from
    final todo = widget.todo;
    if (todo == null) {
      print("No update");
      return;
    }
    final id = todo['_id'];

    final isSuccess = await TodoService.updateTodo(id, body);

    //Show success or fail message based on status
    if (isSuccess) {
      print("Update Success");
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: "Update Success !");
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: "Update Failed !");
    }
  }

  //for Submit button
  Future<void> submitData() async {
    final isSuccess = await TodoService.addTodo(body);

    //Show success or fail message based on status
    if (isSuccess) {
      print("Creation Success");
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: "Creation Success !");
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: "Creation Failed !");
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
