
import 'package:go_router/go_router.dart';
import 'package:push_notifications/presentation/screens/details_screen.dart';
import 'package:push_notifications/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
      ),

    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) => DetailsScreen(pushMessageId: state.pathParameters['messageId'] ?? ''),
      )  
  ]
);