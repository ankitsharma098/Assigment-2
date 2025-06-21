import 'package:equatable/equatable.dart';

import '../model/box_model.dart';

abstract class BoxState extends Equatable {
  const BoxState();

  @override
  List<Object> get props => [];
}

class BoxInitial extends BoxState {}

class BoxLoading extends BoxState {}

class BoxGenerated extends BoxState {
  final List<BoxModel> boxes;
  final bool isAnimating;
  final List<int> clickOrder;

  const BoxGenerated({
    required this.boxes,
    this.isAnimating = false,
    this.clickOrder = const [],
  });

  BoxGenerated copyWith({
    List<BoxModel>? boxes,
    bool? isAnimating,
    List<int>? clickOrder,
  }) {
    return BoxGenerated(
      boxes: boxes ?? this.boxes,
      isAnimating: isAnimating ?? this.isAnimating,
      clickOrder: clickOrder ?? this.clickOrder,
    );
  }

  @override
  List<Object> get props => [boxes, isAnimating, clickOrder];
}
