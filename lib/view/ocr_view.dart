import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/ocr_bloc.dart';
import 'package:project/bloc/ocr_event.dart';
import 'package:project/bloc/ocr_state.dart';

class OcrView extends StatelessWidget {
  const OcrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clean OCR Scanner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BlocBuilder<OcrBloc, OcrState>(
              builder: (context, state) {
                if (state is OcrSuccess) {
                  return Column(
                    children: [
                      Image.file(state.image, height: 250, fit: BoxFit.cover),
                      const SizedBox(height: 20),
                      SelectableText(state.extractedText),
                    ],
                  );
                } else if (state is OcrLoading) {
                  return const CircularProgressIndicator();
                } else if (state is OcrError) {
                  return Text(state.message, style: const TextStyle(color: Colors.red));
                }
                return const Text("Pick an image to start.");
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<OcrBloc>().add(PickImageEvent()),
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
