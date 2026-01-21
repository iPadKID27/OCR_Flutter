import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<String> scanImage(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text.isEmpty ? "No text found." : recognizedText.text;
    } catch (e) {
      throw Exception('Failed to scan image: $e');
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
