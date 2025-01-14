import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:study_buds/blocs/basic_search/bloc/basic_search_bloc.dart';
import 'package:study_buds/blocs/join_group/bloc/join_group_bloc.dart';
import 'package:study_buds/widgets/group_card.dart';

import '../../blocs/group_details/bloc/group_details_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BasicSearchPage(key: Key('search_page'), title: "heyy"),
    );
  }
}

class BasicSearchPage extends StatelessWidget {
  const BasicSearchPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GroupDetailsBloc>(create: (_) => GroupDetailsBloc()),
        Provider<JoinGroupBloc>(create: (_) => JoinGroupBloc()),
      ],
      child: BlocProvider(
        create: (_) => BasicSearchBloc()..add(SuggestedGroupsEvent()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Search for a study group',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            foregroundColor: Theme.of(context).primaryColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _SearchBar(),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<BasicSearchBloc, BasicSearchState>(
                    builder: (context, state) {
                      if (state is SearchSuccess || state is SearchLoading) {
                        return _SearchResults();
                      } else {
                        return _SuggestedGroups();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: Key('search_bar'),
      controller: _searchController,
      onSubmitted: (String query) {
        context.read<BasicSearchBloc>().add(SearchQueryChanged(query));
      },
      decoration: InputDecoration(
        hintText: 'Search...',
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => _searchController.clear(),
        ),
        prefixIcon: IconButton(
          key: Key('search_button'),
          icon: Icon(Icons.search),
          onPressed: () {
            context
                .read<BasicSearchBloc>()
                .add(SearchQueryChanged(_searchController.text));
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicSearchBloc, BasicSearchState>(
      builder: (context, state) {
        if (state is SearchInitial) {
          return Center(child: Text('Enter a query to search for groups.'));
        } else if (state is SearchLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SearchSuccess) {
          final groups = state.groups;
          if (groups.isEmpty) {
            return Center(
                key: Key('no_results_message'),
                child: Text('No results found.'));
          }
          return ListView.builder(
            key: Key('search_results'),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GroupCard(group: group, index: index),
                  Divider(),
                ],
              );
            },
          );
        } else if (state is SearchFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}

class _SuggestedGroups extends StatefulWidget {
  @override
  State<_SuggestedGroups> createState() => _SuggestedGroupsState();
}

class _SuggestedGroupsState extends State<_SuggestedGroups> {
  int _currentIndex = 0; // The current Swiper index

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicSearchBloc, BasicSearchState>(
      builder: (context, state) {
        if (state is SuggestedGroupListLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SuggestedGroupListSuccess) {
          final suggestedGroups = state.suggested_groups;

          if (suggestedGroups.isEmpty) {
            return Center(child: Text('No results found.'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Maybe you'd like to join...",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              // Swiper containing the cards
              SizedBox(
                height: 200,
                child: Swiper(
                  itemCount: suggestedGroups.length,
                  itemBuilder: (BuildContext context, int index) {
                    final group = suggestedGroups[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GroupCard(
                        key: Key('suggested_group_name_$index'),
                        group: group,
                        index: index,
                      ),
                    );
                  },
                  viewportFraction: 0.9,
                  scale: 0.95,
                  onIndexChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  pagination: null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  suggestedGroups.length,
                  (index) => Container(
                    width: 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is SuggestedGroupListFailure) {
          return Center(child: Text('Error: ${state.error}'));
        } else {
          return Center(child: Text(''));
        }
      },
    );
  }
}
