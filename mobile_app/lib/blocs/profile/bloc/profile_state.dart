part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  // Add isLoading as a computed property for all states
  bool get isLoading => false;

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  @override
  bool get isLoading => true;
}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [];
}

class ProfileSaving extends ProfileState {
  @override
  bool get isLoading => true;
}

class ProfileSaveSuccess extends ProfileState {
  final Profile profile;

  const ProfileSaveSuccess(this.profile);
}

class ProfileSaveFailed extends ProfileState {
  final String error;

  const ProfileSaveFailed({required this.error});

  @override
  List<Object> get props => [error];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError({required this.error});

  @override
  List<Object> get props => [error];
}
