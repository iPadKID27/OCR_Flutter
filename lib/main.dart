import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/ocr_bloc.dart';
import 'package:project/repositories/ocr_repository.dart';
import 'package:project/view/ocr_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RepositoryProvider(
        create: (context) => OcrRepository(),
        child: BlocProvider(
          create: (context) => OcrBloc(context.read<OcrRepository>()),
          child: const OcrScreen(),
        ),
      ),
    );
  }
}
