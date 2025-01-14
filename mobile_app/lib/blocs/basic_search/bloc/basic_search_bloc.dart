import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:study_buds/models/group.dart';
import 'package:study_buds/network/request/basic_search_request.dart';
import 'package:study_buds/network/request/sugged_groups_request.dart';

part 'basic_search_event.dart';
part 'basic_search_state.dart';

class BasicSearchBloc extends Bloc<BasicSearchEvent, BasicSearchState> {
  BasicSearchBloc() : super(BasicSearchInitial()) {
    on<SuggestedGroupsEvent>((event, emit) async {
      emit(SuggestedGroupListLoading());
      try {
        final suggestedGroupsRequest =
            SuggestedGroupsRequest();
        final response = await suggestedGroupsRequest.send();
        if (response.isSuccess) {
          final List<Group> suggestedGroups =
              Group.fromJsonList(response.data ?? []);
          emit(SuggestedGroupListSuccess(suggestedGroups));
        } else {
          emit(SuggestedGroupListFailure(
              'Failed to get Suggested Group list'));
        }
      } catch (e) {
        print(e);
        emit(SuggestedGroupListFailure(
            'Failed to send Suggested Group list request'));
      }
    });

    // Handle SearchQueryChanged
    on<SearchQueryChanged>((event, emit) async {
      emit(SearchLoading());
      try {
        final basicSearchRequest = BasicSearchRequest(
            query: event.queryString);
        final response = await basicSearchRequest.send();
        if (response.isSuccess) {
          final List<Group> groups = Group.fromJsonList(response.data ?? []);
          emit(SearchSuccess(groups));
        } else {
          emit(SearchFailure('Failed to search'));
        }
      } catch (e) {
        print(e);
        emit(SearchFailure('Failed to send request'));
      }
    });
  }
}
