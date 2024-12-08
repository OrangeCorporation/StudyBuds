part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileDetailsEvent extends ProfileEvent {}

class SaveProfileDetailsEvent extends ProfileEvent {
  final String telegramAccountId;

  const SaveProfileDetailsEvent(this.telegramAccountId);

  @override
  List<Object> get props => [telegramAccountId];
}
