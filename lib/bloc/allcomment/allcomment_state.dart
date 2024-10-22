part of 'allcomment_bloc.dart';

sealed class AllcommentState extends Equatable {
  const AllcommentState();

  @override
  List<Object> get props => [];
}

final class AllcommentInitial extends AllcommentState {}

final class AllcommentLoading extends AllcommentState {}

final class AllcommentLoaded extends AllcommentState {
  final Allcoment comments;

  AllcommentLoaded({
    required this.comments,
  });

  @override
  List<Object> get props => [comments];
}

final class AllcommentError extends AllcommentState {
  final String message;

  AllcommentError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class AllcommentEmpty extends AllcommentState {}
