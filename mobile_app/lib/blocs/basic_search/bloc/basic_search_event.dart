part of 'basic_search_bloc.dart';

sealed class BasicSearchEvent extends Equatable {}

class SuggestedGroupsEvent extends BasicSearchEvent {
  SuggestedGroupsEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends BasicSearchEvent {
  final String queryString;

  SearchQueryChanged(this.queryString);

  @override
  List<Object?> get props => [queryString];
}
