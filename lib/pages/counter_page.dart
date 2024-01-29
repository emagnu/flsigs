//   //
// Import LIBRARIES
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

// Import FILES
//  PARTS
//  SIGNALS
final counter = signal<int>(0);
//   //

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Counter Page'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0),
              ),
              Text(
                // counter.value.toString(),
                '${counter.watch(context)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // FloatingActionButton.extended(
            //   backgroundColor: Colors.red,
            //   onPressed: () => counter.value--,
            //   tooltip: 'Increment',
            //   label: const Text('Tap to decrease'),
            //   icon: const Icon(Icons.remove),
            // ),
            FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              onPressed: () => counter.value++,
              tooltip: 'Increment',
              label: const Text('Tap to increase'),
              icon: const Icon(Icons.add),
            ),
          ],
        ));
  }
}
