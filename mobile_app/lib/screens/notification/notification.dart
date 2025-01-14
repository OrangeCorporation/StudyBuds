import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_buds/blocs/notification_list/bloc/notification_list_bloc.dart';
import 'package:study_buds/models/notification.dart';
import 'package:study_buds/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> receivedJoinRequest = [];
  List<NotificationModel> joinRequestResult = [];

  listChangedEvent(){
    NotificationListBloc()..add(FetchNotificationListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child:Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              overlayColor: WidgetStatePropertyAll(Color(0x25FFFFFF)),
              indicatorColor: Theme.of(context).colorScheme.secondary,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(key: Key("received_join_request"), text: 'Received join request'),
                Tab(key: Key("join_request_result"), text: 'Join request result'),
              ],),
            elevation: 0,
            foregroundColor: Theme.of(context).primaryColor,
          ),
          body: BlocProvider(
            create: (_) => NotificationListBloc()..add(FetchNotificationListEvent()),
            child: Scaffold(
              body: BlocConsumer<NotificationListBloc, NotificationListState>(
                listener: (context, state) {
                  if (state is NotificationListSuccess) {
                    receivedJoinRequest = state.received;
                    joinRequestResult = state.responseList;
                  } else if (state is NotificationListFailure) {
                    receivedJoinRequest = [];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return TabBarView(children: [
                    NotificationListTab(models: receivedJoinRequest),
                    NotificationListTab(models: joinRequestResult)
                  ],
                  );
                },
              ),
            ),
          ),
        )
      )
    );
  }
}

class NotificationListTab extends StatelessWidget {
  final List<NotificationModel> models;

  const NotificationListTab({super.key, required this.models});

  void listChangedEvent(BuildContext context) {
    BlocProvider.of<NotificationListBloc>(context)
        .add(FetchNotificationListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          listChangedEvent(context);
        },
        child: ListView.builder(
          itemCount: models.length,
          itemBuilder: (context, index) {
            final notification = models[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 16.0,
              ),
              child: NotificationCard(
                backgroundColor: Colors.white,
                notification: notification,
                listChanged: () => listChangedEvent(context),
              ),
            );
          },
        ),
      ),
    );
  }
}
