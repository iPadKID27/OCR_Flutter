import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ocr_bloc.dart';
import '../bloc/ocr_event.dart';
import '../bloc/ocr_state.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  // Controller to allow editing the detected amount
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Expense Scanner",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<OcrBloc, OcrState>(
        listener: (context, state) {
          if (state is OcrError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          // If success, pre-fill the edit text controller with the found amount
          if (state is OcrSuccess) {
             _amountController.text = state.expense.formattedAmount;
          }
        },
        builder: (context, state) {
          if (state is OcrLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OcrSuccess) {
            return _buildSuccessView(context, state);
          } else {
            return _buildEmptyState(context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<OcrBloc>().add(PickImageEvent()),
        label: const Text("Scan Slip"),
        icon: const Icon(Icons.camera_alt_outlined),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text("No slip scanned", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, OcrSuccess state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. The Image Preview
          Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: SizedBox(
              height: 200,
              child: Image.file(state.image, fit: BoxFit.cover, alignment: Alignment.topCenter),
            ),
          ),
          const SizedBox(height: 24),

          // 2. The Summary Card
          Card(
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
             elevation: 4,
             child: Padding(
               padding: const EdgeInsets.all(20.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text("Total Amount", style: TextStyle(color: Colors.grey, fontSize: 14)),
                   const SizedBox(height: 8),
                   // Editable Text Field for the amount
                   TextField(
                     controller: _amountController,
                     keyboardType: const TextInputType.numberWithOptions(decimal: true),
                     style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                     decoration: const InputDecoration(
                       prefixText: "฿ ", // Thai Baht symbol, adjust if needed
                       border: InputBorder.none,
                       isDense: true,
                       contentPadding: EdgeInsets.zero
                     ),
                   ),
                   const Divider(height: 30),
                   Text("Scan confidence: Automatic detection based on largest numerical value found.", style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic)),
                 ],
               ),
             ),
          ),
          
          const SizedBox(height: 20),
          
          // 3. Save Button (Mock functionality)
          ElevatedButton(
            onPressed: () {
              // Here you would save _amountController.text to your database
              final finalAmount = double.tryParse(_amountController.text) ?? 0.0;
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved expense: ฿$finalAmount"))
              );
              // Optional: Reset state
              // context.read<OcrBloc>().add(ResetEvent()); 
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            child: const Text("Save Expense", style: TextStyle(fontSize: 18, color: Colors.white)),
          ),

           const SizedBox(height: 20),
           // 4. Expander for raw text (debugging)
           ExpansionTile(
             title: const Text("View Raw OCR Text"),
             children: [
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: SelectableText(state.expense.rawText, style: const TextStyle(fontSize: 12)),
               )
             ],
           ),
           const SizedBox(height: 80),
        ],
      ),
    );
  }
}