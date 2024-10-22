part of 'allcomment_bloc.dart';

sealed class AllcommentEvent extends Equatable {
  const AllcommentEvent();

  @override
  List<Object> get props => [];
}

class AllcommentFetch extends AllcommentEvent {
  final String bookID;

  AllcommentFetch({
    required this.bookID,
  });

  @override
  List<Object> get props => [bookID];
}
