// main.dart
import 'package:assignment2/task/bloc/box_bloc.dart';
import 'package:assignment2/task/ui/box_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive Box Layout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: BlocProvider(
        create: (context) => BoxBloc(),
        child: const BoxLayoutScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
