//   //
// Import LIBRARIES
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signals/signals_flutter.dart';
//   //
// Import FILES
//  PARTS
//  SIGNALS
//  OTHERS
//  https://v2.jokeapi.dev/joke/[Category/-ies]
// https://v2.jokeapi.dev/joke/Any?safe-mode
// https://v2.jokeapi.dev/joke/programming?type=twopart&blacklistFlags=nsfw,religious,political,racist,sexist,explicit
//   //

const String apiUrl =
    'https://v2.jokeapi.dev/joke/programming?type=twopart&blacklistFlags=nsfw,religious,political,racist,sexist,explicit';

typedef Joke = ({String setup, String delivery});

final s = asyncSignal<Joke?>(AsyncState.data(null));

Future<void> getJoke() async {
  s.value = AsyncState.loading();

  try {
    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);
    if (data['error']) {
      s.value = AsyncState.error('Error', null);
      return;
    }
    final Joke joke = (setup: data['setup'], delivery: data['delivery']);
    s.value = AsyncState.data(joke);
  } catch (e, st) {
    s.value = AsyncState.error(e, st);
  }
}

class HttpPage extends StatelessWidget {
  const HttpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Http Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () {
                getJoke();
              },
              icon: const Icon(Icons.refresh),
            ),
            Watch.builder(
              builder: (context) {
                if (s.value.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (s.value.hasError) {
                  return Center(
                    child: Text(s.value.error.toString()),
                  );
                }
                final joke = s.value
                    .value; // s.value(value of the async state).value(value in that async state)
                if (joke == null) {
                  return const Text('Tap the button to load a joke');
                }

                // return const Text('....');
                return Text(
                  '\n${joke.setup}\n${joke.delivery}',
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
