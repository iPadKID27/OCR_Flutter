import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:project/models/expense_model.dart';

abstract class OcrState extends Equatable {
  const OcrState();
  @override
  List<Object?> get props => [];
}

class OcrInitial extends OcrState {}

class OcrLoading extends OcrState {}

class OcrSuccess extends OcrState {
  final File image;
  final ExpenseModel expense;

  const OcrSuccess(this.image, this.expense);
  @override
  List<Object> get props => [image, expense];
}

class OcrError extends OcrState {
  final String message;
  const OcrError(this.message);
  @override
  List<Object> get props => [message];
}
