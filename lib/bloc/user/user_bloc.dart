import 'package:bloc/bloc.dart';
import 'package:bloctest/models/user_model.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
    on<SearchUser>(_onSearchUser);
  }

  void _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await userRepository.getUsers();
      checkNoData(users, emit);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onAddUser(AddUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.createUser(name: event.name, email: event.email);
      final users = await getUser();
      checkNoData(users, emit);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.updateUser(event.user);
      final users = await getUser();
      checkNoData(users, emit);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await userRepository.deleteUser(event.user);
      final users = await getUser();
      checkNoData(users, emit);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onSearchUser(SearchUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await userRepository.searchUsers(event.query);
      checkNoData(users, emit);
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void checkNoData(List<User> users, Emitter<UserState> emit) {
    if (users.isEmpty) {
      emit(UserNoData());
    } else {
      emit(UserLoaded(users));
    }
  }

  Future<List<User>> getUser() async {
    final users = await userRepository.getUsers();
    return users;
  }
}
