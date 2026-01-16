import 'package:go_router/go_router.dart';
import 'package:journal/screens/home_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'router_notifier.g.dart';



@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(title: 'Journal'),
      ),
    ],
  );
}
