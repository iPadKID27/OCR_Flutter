import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class OcrState extends Equatable {
  const OcrState();
  @override
  List<Object?> get props => [];
}

class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

class OcrSuccess extends OcrState {
  final File image;
  final String extractedText;

  const OcrSuccess(this.image, this.extractedText);
  @override
  List<Object> get props => [image, extractedText];
}

class OcrError extends OcrState {
  final String message;
  const OcrError(this.message);
  @override
  List<Object> get props => [message];
}
