//   //
// Import LIBRARIES
import 'package:flutter/material.dart';
// Import FILES
import '../models/nav_item.dart';
import 'counter_page.dart';
import 'http_page.dart';
import 'todo_page.dart';
//  PARTS
//  SIGNALS
//   //

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: ListView(
        children: const <Widget>[
          NavItem(
            label: 'Counter',
            screen: CounterPage(),
          ),
          NavItem(
            label: 'Todos',
            screen: TodoPage(),
          ),
          NavItem(
            label: 'Http',
            screen: HttpPage(),
          ),
        ],
      ),
    );
  }
}
