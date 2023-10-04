import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:push_app/presentation/blocs/notification/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: context
              .select((NotificationsBloc bloc) => Text('${bloc.state.status}')),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<NotificationsBloc>().requestPermission();
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: const _HomeView());
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationsBloc>().state.notification;

    return ListView.builder(
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
            onTap: () {
              context.push('/push-details/${notification.messageId}');
            },
            title: Text(notification.title),
            subtitle: Text(notification.body),
            leading: notification.imageUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(notification.imageUrl!),
                  )
                : null);
      },
      itemCount: notifications.length,
    );
  }
}
