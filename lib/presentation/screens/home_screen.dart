


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notifications/presentation/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) => Text('Permisos: ${bloc.state.status}')
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            context.read<NotificationsBloc>().requestPermision();
          }, 
          icon: Icon(Icons.settings)
          )
        ],
      ),
      body: _HomeView(),
    );
  }
}



class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 0,
      
      itemBuilder: (context, index) {
        return ListTile();
      },
    );
  }
}