import 'package:flutter/material.dart';
import 'package:header/header_fixed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fixed headers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HeaderFixed(
        listItens: [
          testList(),
          testList2(),
          testList3(),
          testList(),
          testList2(),
          testList3(),
          testList(),
          testList2(),
          testList3()
        ],
      ),
    );
  }
}

List<Widget> testList() {
  return [
    Container(
        alignment: Alignment.center,
        height: 150,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: const Text("Header 1")),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
  ];
}

List<Widget> testList2() {
  return [
    Container(
        alignment: Alignment.center,
        height: 150,
        color: Colors.red,
        child: const Text("Header 1")),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
  ];
}

List<Widget> testList3() {
  return [
    Container(
        alignment: Alignment.center,
        height: 150,
        color: Colors.green,
        child: const Center(
          child: Text(
            "Header 3",
          ),
        )),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
    Container(height: 150, color: Colors.yellowAccent),
    Container(height: 150, color: Colors.yellow),
  ];
}
