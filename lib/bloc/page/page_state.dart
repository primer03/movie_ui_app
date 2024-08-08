part of 'page_bloc.dart';

sealed class PageState extends Equatable {
  final int tabIndex;
  PageState({required this.tabIndex});

  @override
  List<Object> get props => [tabIndex];
}

final class PageInitial extends PageState {
  PageInitial({required int tabIndex}) : super(tabIndex: tabIndex);
}

final class ScrollPage extends PageState {
  final bool isScrolling;
  final bool showAppBar;
  ScrollPage({
    required int tabIndex,
    required this.isScrolling,
    required this.showAppBar,
  }) : super(tabIndex: tabIndex);

  @override
  List<Object> get props => [isScrolling, showAppBar];
}
