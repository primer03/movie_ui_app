part of 'page_bloc.dart';

sealed class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object> get props => [];
}

final class PageChanged extends PageEvent {
  final int tabIndex;
  const PageChanged({required this.tabIndex});
}

final class PageScroll extends PageEvent {
  final bool isScrolling;
  const PageScroll({required this.isScrolling});
}
