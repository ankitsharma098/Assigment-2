// bloc/box_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/box_model.dart';
import 'box_event.dart';
import 'box_state.dart';

class BoxBloc extends Bloc<BoxEvent, BoxState> {
  Timer? _reverseTimer;

  BoxBloc() : super(BoxInitial()) {
    on<GenerateBoxes>(_onGenerateBoxes);
    on<ToggleBox>(_onToggleBox);
    on<StartReverseAnimation>(_onStartReverseAnimation);
    on<ReverseAnimationTick>(_onReverseAnimationTick);
    on<ResetBoxes>(_onResetBoxes);
  }

  void _onGenerateBoxes(GenerateBoxes event, Emitter<BoxState> emit) {
    final boxes = List.generate(
      event.count,
      (index) => BoxModel(index: index),
    );
    emit(BoxGenerated(boxes: boxes));
  }

  void _onToggleBox(ToggleBox event, Emitter<BoxState> emit) {
    if (state is BoxGenerated) {
      final currentState = state as BoxGenerated;

      if (currentState.isAnimating) return;

      final boxes = List<BoxModel>.from(currentState.boxes);
      final clickOrder = List<int>.from(currentState.clickOrder);

      final boxIndex = boxes.indexWhere((box) => box.index == event.index);
      if (boxIndex != -1 && !boxes[boxIndex].isGreen) {
        clickOrder.add(event.index);
        boxes[boxIndex] = boxes[boxIndex].copyWith(
          isGreen: true,
          clickOrder: clickOrder.length,
        );

        final newState = currentState.copyWith(
          boxes: boxes,
          clickOrder: clickOrder,
        );

        emit(newState);

        // Check if all boxes are green
        if (boxes.every((box) => box.isGreen)) {
          add(const StartReverseAnimation());
        }
      }
    }
  }

  void _onStartReverseAnimation(
      StartReverseAnimation event, Emitter<BoxState> emit) {
    if (state is BoxGenerated) {
      final currentState = state as BoxGenerated;
      emit(currentState.copyWith(isAnimating: true));

      _reverseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(const ReverseAnimationTick());
      });
    }
  }

  void _onReverseAnimationTick(
      ReverseAnimationTick event, Emitter<BoxState> emit) {
    if (state is BoxGenerated) {
      final currentState = state as BoxGenerated;
      final boxes = List<BoxModel>.from(currentState.boxes);
      final clickOrder = List<int>.from(currentState.clickOrder);

      if (clickOrder.isNotEmpty) {
        final lastClickedIndex = clickOrder.removeLast();
        final boxIndex =
            boxes.indexWhere((box) => box.index == lastClickedIndex);

        if (boxIndex != -1) {
          boxes[boxIndex] = boxes[boxIndex].copyWith(
            isGreen: false,
            clickOrder: null,
          );
        }

        emit(currentState.copyWith(
          boxes: boxes,
          clickOrder: clickOrder,
        ));

        if (clickOrder.isEmpty) {
          _reverseTimer?.cancel();
          emit(currentState.copyWith(
            boxes: boxes,
            clickOrder: clickOrder,
            isAnimating: false,
          ));
        }
      }
    }
  }

  void _onResetBoxes(ResetBoxes event, Emitter<BoxState> emit) {
    _reverseTimer?.cancel();
    emit(BoxInitial());
  }

  @override
  Future<void> close() {
    _reverseTimer?.cancel();
    return super.close();
  }
}
