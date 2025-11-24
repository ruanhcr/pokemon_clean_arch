import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_clean_arch/core/routing/app_router.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_bloc.dart';
import 'package:pokemon_clean_arch/pokemon/presentation/bloc/favorites/favorite_event.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.I.get<FavoriteBloc>()..add(LoadFavoritesEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Clean Arch PokeAPI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        routerConfig: appRouter,
      ),
    );
  }
}
