import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entitites/user_entity.dart';
import '../../domain/usecases/sign_in_usecase.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final SignInUseCase signInUseCase;
  UserCubit({
    required this.signInUseCase,
  }) : super(UserInitial());

  Future<void> submitSignIn(
      {required UserEntity user, required BuildContext context}) async {
    emit(UserLoading());
    try {
      await signInUseCase.call(user, context);
      emit(UserSuccess());
    } on SocketException catch (e) {
      emit(UserFailure(message: e.message));
    } catch (e) {
      emit(UserFailure(message: e.toString()));
    }
  }
}
