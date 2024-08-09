part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  final int pageIndex;
  const OnboardingState({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial({required int pageIndex})
      : super(pageIndex: pageIndex);
}

class OnboardingPageChange extends OnboardingState {
  const OnboardingPageChange({required int pageIndex})
      : super(pageIndex: pageIndex);
}

class OnboardingComplete extends OnboardingState {
  final List<bool> isCompleted;
  const OnboardingComplete({required this.isCompleted, required int pageIndex})
      : super(pageIndex: pageIndex);

  @override
  List<Object> get props => [isCompleted, pageIndex];
}
