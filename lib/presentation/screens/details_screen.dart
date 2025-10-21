
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notifications/domain/entities/push_message.dart';
import 'package:push_notifications/presentation/blocs/notifications/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;
  const DetailsScreen({required this.pushMessageId, super.key});

  @override
  Widget build(BuildContext context) {

    final PushMessage? message = context.watch<NotificationsBloc>().getMessageById(pushMessageId);


    return Scaffold(
      appBar: AppBar(
        title: Text('data'),
      ),
      body: (message != null)
      ? _DetailsView(message: message)
      : Center(child: Text('sin notificaciones'),),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage message;
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null)
          Image.network(message.imageUrl!),


          SizedBox(height: 20),


          Text(message.title, style: textStyle.titleMedium),
          Text(message.body),

          Divider(),

          Text(message.data.toString())



        ],
      ),
    );
  }
}