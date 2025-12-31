import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;
  int zeroCounter = 0;
  bool isDisabled = false;
  List<int> history = [];

  void tambah() {
    if (isDisabled) return;

    setState(() {
      counter++;
      _afterAction();
    });
  }

  void kurang() {
    if (isDisabled) return;

    setState(() {
      counter--;
      _afterAction();
    });
  }

  void _afterAction() {
    history.insert(0, counter);
    if (history.length > 5) {
      history.removeLast();
    }

    if (counter == 0) {
      zeroCounter++;
    }

    if (zeroCounter == 3) {
      isDisabled = true;
      _showDialog();
    }
  }

  void reset() {
    setState(() {
      counter = 0;
      zeroCounter = 0;
      isDisabled = false;
      history.clear();
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Alert!'),
          content: const Text('Angka 0 dah nyentuh 3 kali!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Logic'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nilai Saat Ini'),
            const SizedBox(height: 10),
            Text(
              '$counter',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Zero Count: $zeroCounter / 3',
              style: const TextStyle(fontSize: 18, color: Colors.orange),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isDisabled ? null : kurang,
                  child: const Text('Kurang'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isDisabled ? null : tambah,
                  child: const Text('Tambah'),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Text('Riwayat'),
            const SizedBox(height: 10),
            Container(
              width: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: history.isEmpty
                  ? const Text('Belum ada')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: history
                          .map((e) => Text(e.toString()))
                          .toList(),
                    ),
            ),

            if (isDisabled)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Tombol dinonaktifkan, tekan Reset',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
