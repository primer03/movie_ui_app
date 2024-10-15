import 'package:bloc/bloc.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
part 'changepassword_event.dart';
part 'changepassword_state.dart';

class ChangepasswordBloc
    extends Bloc<ChangepasswordEvent, ChangepasswordState> {
  ChangepasswordBloc() : super(ChangepasswordInitial()) {
    on<ChangePassword>(_onChangePassword);
  }

  UserRepository userRepository = UserRepository();

  void _onChangePassword(
      ChangePassword event, Emitter<ChangepasswordState> emit) async {
    emit(ChangepasswordLoading());
    try {
      final response = await userRepository.changePassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      emit(ChangepasswordSuccess(message: response));
    } catch (e) {
      emit(ChangepasswordFailure(error: e.toString()));
    }
  }
}
