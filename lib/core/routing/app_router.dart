import 'package:go_router/go_router.dart';
import '../../modules/pokemon/presentation/pages/pokemon_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PokemonPage(),
    ),
  ],
);