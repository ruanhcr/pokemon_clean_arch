import 'package:go_router/go_router.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/pages/detail/pokemon_detail_page.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/pages/list/pokemon_list_page.dart';
import '../../modules/pokemon/presentation/pages/search/pokemon_search_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const PokemonListPage()),
    GoRoute(
      path: '/pokemon/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PokemonDetailPage(id: id);
      },
    ),
    GoRoute(path: '/search', builder: (context, state) => const PokemonSearchPage()),
  ],
);
