import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:study_buds/network/request/profile_request.dart';
import 'package:study_buds/network/request/update_telegram_account.dart';
import 'package:hive/hive.dart';
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

      // hive caching
      // open the Hive box
      final box = Hive.box<Student>('profiles');

      // check if data is cached
      final cachedStudent = box.get('user_profile');
      if (cachedStudent != null) {
        emit(ProfileLoaded(cachedStudent));
        return;
      }
      final request = ProfileRequest();
      final response = await request.send();

      if (response.isSuccess) {
        //caching 
        final student = Student.fromJson(response.data);

        // cache the fetched data
        await box.put('user_profile', student);
        //end caching

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
        //caching
        final student = Student.fromJson(response.data);

        // update the cached data
        final box = Hive.box<Student>('profiles');
        await box.put('user_profile', student);
        //end caching

        emit(ProfileSaveSuccess(response.data));
      } else {
        emit(ProfileSaveFailed(error: 'Failed to update telegram account'));
      }
    } catch (e) {
      emit(ProfileSaveFailed(error: 'Failed to save profile details.'));
    }
  }
}
