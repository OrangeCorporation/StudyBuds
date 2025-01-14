part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileDetailsEvent extends ProfileEvent {
  FetchProfileDetailsEvent();
}

class SaveProfileDetailsEvent extends ProfileEvent {
  final int telegramAccountId;

  const SaveProfileDetailsEvent( this.telegramAccountId);

  @override
  List<Object> get props => [telegramAccountId];
}
