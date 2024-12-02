import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Ensure this class is defined if not already in your main app
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Counter: $_counter'),
              ElevatedButton(
                key: const Key('incrementButton'),
                onPressed: _incrementCounter,
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const CounterApp());

    // Verify that our counter starts at 0
    expect(find.text('Counter: 0'), findsOneWidget);

    // Tap the '+' icon and trigger a frame
    await tester.tap(find.byKey(const Key('incrementButton')));
    await tester.pump();

    // Verify that our counter has incremented
    expect(find.text('Counter: 1'), findsOneWidget);
  });
}
