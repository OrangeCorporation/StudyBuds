import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_buds/network/request/profile_request.dart';
import 'package:study_buds/network/request/update_telegram_account.dart';

import '../../../models/student.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileDetailsEvent>(_onFetchProfileDetails);
    on<SaveProfileDetailsEvent>(_onSaveProfileDetails);
  }

  Future<void> _onFetchProfileDetails(
      FetchProfileDetailsEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileLoading());
      final request = ProfileRequest();
      final response = await request.send();

      if (response.isSuccess) {
        emit(ProfileLoaded(response.data));
      } else {
        emit(ProfileError(error: 'Failed to get profile information'));
      }
    } catch (e) {
      emit(ProfileError(error: 'Failed to fetch profile details.'));
    }
  }

  Future<void> _onSaveProfileDetails(
      SaveProfileDetailsEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(ProfileSaving());
      final request = UpdateTelegramAccountRequest(event.telegramAccountId);
      final response = await request.send();
      if (response.isSuccess) {
        emit(ProfileSaveSuccess(response.data));
      } else {
        emit(ProfileSaveFailed(error: 'Failed to update telegram account'));
      }
    } catch (e) {
      emit(ProfileSaveFailed(error: 'Failed to save profile details.'));
    }
  }
}
