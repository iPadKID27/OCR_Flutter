import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/ocr_event.dart';
import 'package:project/bloc/ocr_state.dart';
import 'package:project/repositories/ocr_repository.dart';

class OcrBloc extends Bloc<OcrEvent, OcrState> {
  final OcrRepository _repository;

  OcrBloc(this._repository) : super(OcrInitial()) {
    on<PickImageEvent>(_onPickImage);
  }

  Future<void> _onPickImage(PickImageEvent event, Emitter<OcrState> emit) async {
    try {
      emit(OcrLoading());
      final image = await _repository.pickImage();
      if (image == null) {
        emit(OcrInitial());
        return;
      }
      final text = await _repository.scanImage(image);
      emit(OcrSuccess(image, text));
    } catch (e) {
      emit(OcrError(e.toString()));
    }
  }
}
