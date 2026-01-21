import 'package:equatable/equatable.dart';

abstract class OcrEvent extends Equatable {
  const OcrEvent();
  @override
  List<Object> get props => [];
}

class PickImageEvent extends OcrEvent{}