// bloc/box_events.dart

import 'package:equatable/equatable.dart';

abstract class BoxEvent extends Equatable {
  const BoxEvent();

  @override
  List<Object> get props => [];
}

class GenerateBoxes extends BoxEvent {
  final int count;

  const GenerateBoxes(this.count);

  @override
  List<Object> get props => [count];
}

class ToggleBox extends BoxEvent {
  final int index;

  const ToggleBox(this.index);

  @override
  List<Object> get props => [index];
}

class StartReverseAnimation extends BoxEvent {
  const StartReverseAnimation();
}

class ReverseAnimationTick extends BoxEvent {
  const ReverseAnimationTick();
}

class ResetBoxes extends BoxEvent {
  const ResetBoxes();
}
