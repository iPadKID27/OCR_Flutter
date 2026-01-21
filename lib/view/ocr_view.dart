import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ocr_bloc.dart';
import '../bloc/ocr_event.dart';
import '../bloc/ocr_state.dart';

class OcrView extends StatelessWidget {
  const OcrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Softer background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Scanner",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Clear Button (Optional)
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black54),
            onPressed: () => context.read<OcrBloc>().add(PickImageEvent()),
          ),
        ],
      ),
      body: BlocConsumer<OcrBloc, OcrState>(
        listener: (context, state) {
          if (state is OcrError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is OcrLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Processing Image...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          } else if (state is OcrSuccess) {
            return _buildSuccessView(context, state);
          } else {
            return _buildEmptyState(context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<OcrBloc>().add(PickImageEvent()),
        label: const Text("Scan Document"),
        icon: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }

  // 1. The Empty State (Initial View)
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.document_scanner_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No image selected",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap the button below to start",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 2. The Success View (Image + Text)
  Widget _buildSuccessView(BuildContext context, OcrSuccess state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Preview Card
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: SizedBox(
              height: 250,
              child: Image.file(
                state.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Header with Copy Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Extracted Text",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              IconButton(
                icon: const Icon(Icons.copy_all, color: Colors.deepPurple),
                tooltip: "Copy to Clipboard",
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: state.extractedText));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Text copied to clipboard")),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 8),

          // Text Result Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SelectableText(
              state.extractedText,
              style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 80), // Extra space for FAB
        ],
      ),
    );
  }
}