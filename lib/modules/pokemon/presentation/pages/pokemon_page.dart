import 'package:flutter/material.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/pokemon_event.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_state.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final textController = TextEditingController();

  final bloc = GetIt.I.get<PokemonBloc>();

  @override
  void dispose() {
    textController.dispose();
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Clean Arch PokeAPI")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(labelText: 'Nome do Pokémon'),
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () {
                  bloc.add(SearchPokemonEvent(textController.text));
                },
                child: const Text("Buscar"),
              ),
              const SizedBox(height: 32),

              BlocBuilder<PokemonBloc, PokemonState>(
                builder: (context, state) {
                  return switch (state) {
                    PokemonInitialState() => const Text("Pesquise algo..."),
                    PokemonLoadingState() => const CircularProgressIndicator(),
                    PokemonErrorState(message: var msg) => Text(
                      msg,
                      style: const TextStyle(color: Colors.red),
                    ),
                    PokemonSuccessState(pokemon: var p) => Column(
                      children: [
                        Image.network(p.imageUrl),
                        Text(p.name, style: const TextStyle(fontSize: 24)),
                      ],
                    ),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
