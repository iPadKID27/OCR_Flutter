import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/models/expense_model.dart';

class OcrRepository {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  Future<File?> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      return null;
    }
    return File(pickedFile.path);
  }

  Future<ExpenseModel> scanImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Call our internal parsing function
      return _parseReceiptData(recognizedText);

    } catch (e) {
      throw Exception('Failed to scan image: $e');
    }
  }

  ExpenseModel _parseReceiptData(RecognizedText recognizedText) {
    String fullText = recognizedText.text;
    if (fullText.isEmpty) {
      return ExpenseModel(totalAmount: 0.0, rawText: "");
    }

    List<double> foundAmounts = [];
    final priceRegex = RegExp(r'(\d+[.,]\d{2})');
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        final matches = priceRegex.allMatches(line.text);
        for (final match in matches) {
          String numStr = match.group(1) ?? "";
          numStr = numStr.replaceAll(',', '.');
          double? value = double.tryParse(numStr);
          if (value != null) {
             foundAmounts.add(value);
          }
        }
      }
    }

    double bestGuessTotal = 0.0;

    if (foundAmounts.isNotEmpty) {
      foundAmounts.sort((a, b) => b.compareTo(a));
      bestGuessTotal = foundAmounts.first;
       print("Found potential amounts: $foundAmounts");
       print("Selected best guess: $bestGuessTotal");
    }
    return ExpenseModel(
        totalAmount: bestGuessTotal,
        rawText: fullText
    );
  }
  
  void dispose() {
    _textRecognizer.close();
  }
}


