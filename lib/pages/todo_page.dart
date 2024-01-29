//   //
// Import LIBRARIES
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:signals/signals_flutter.dart';
// Import FILES
//  PARTS
// //  SIGNALS

final todos = <Todo>[...initialState].toSignal();

final todoCount = computed(() {
  debugPrint('Inside computed todoCount');
  return todos.length;
});

final activeTodoCount = computed(() {
  debugPrint('Inside computed activeTodoCount');
  return todos.where((todo) => !todo.completed).length;
});

final completedTodoCount = computed(() {
  debugPrint('Inside computed completedTodoCount');
  return todos.where((todo) => todo.completed).length;
});

final filter = signal<Filter>(Filter.all);

final filteredTodos = computed(() {
  debugPrint('filter.value: ${filter.value}');
  debugPrint('Inside computed - filteredTodos');
  final currentFilter = filter.value;
  final currentTodos = todos;

  switch (currentFilter) {
    case Filter.all:
      return currentTodos.toList();
    case Filter.active:
      return todos.where((todo) => !todo.completed).toList();
    case Filter.completed:
      return todos.where((todo) => todo.completed).toList();
  }
});

//   //

// ___________________________________
typedef Todo = ({
  int id,
  String label,
  bool completed,
});

final List<Todo> initialState = [
  (id: 1, label: "read docs", completed: true),
  (id: 2, label: "write code", completed: false),
  (id: 3, label: "ship it", completed: false),
];

enum Filter {
  all("All"),
  active("Active"),
  completed("Completed"),
  ;

  final String label;
  const Filter(this.label);
}

// ___________________________________

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: PopupMenuButton(
              itemBuilder: (context) {
                return Filter.values.map((filter) {
                  return PopupMenuItem(
                    value: filter,
                    child: Text(filter.label),
                  );
                }).toList();
              },
              onSelected: (value) {
                filter.value = value;
              },
              child: Text('Filter: ${filter.watch(context).label}'),
            ),
          )
        ],
      ),
      body: Watch.builder(
        builder: (context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total: ${todoCount.value}\nActive: ${activeTodoCount.value}\nCompleted: ${completedTodoCount.value}',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  // itemCount: todos.length,
                  itemCount: filteredTodos.value.length,
                  itemBuilder: (context, index) {
                    // final todo = todos[index];
                    final todo = filteredTodos.value[index];
                    return Card(
                      child: ListTile(
                        title: Text(todo.label),
                        trailing: Checkbox(
                          value: todo.completed,
                          onChanged: (value) {
                            if (value != null) {
                              // todos[index] = (id: todo.id,label: todo.label,completed: value);
                              final i =
                                  todos.indexWhere((t) => t.id == todo.id);
                              if (i >= 0) {
                                todos[i] = (
                                  id: todo.id,
                                  label: todo.label,
                                  completed: value
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? label = await showDialog<String>(
            context: context,
            builder: (context) {
              debugPrint('Inside showDialog');
              return AlertDialog(
                title: const Text('New Task'),
                content: TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'New Task',
                  ),
                  // onSubmitted: (value) {
                  //   Navigator.of(context).pop(value);
                  // },
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                        // Navigator.of(context).pop(textEditingController.text);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(textEditingController.text);
                        textEditingController.clear();
                      },
                      child: const Text('Add'))
                ],
              );
            },
          );
          if (label != null && label.isNotEmpty) {
            debugPrint('Inside if statement - floatingActionButton');
            debugPrint('todos.length: ${todos.length + 1}');
            debugPrint('label: $label');
            // todos.add((id: todos.length + 1, label: label, completed: false));
            todos
                .add((id: todoCount.value + 1, label: label, completed: false));
          }
          return;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
