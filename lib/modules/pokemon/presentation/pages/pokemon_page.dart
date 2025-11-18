import 'package:flutter/material.dart';
import 'package:pokemon_clean_arch/modules/pokemon/domain/entities/pokemon_entity.dart';
import 'package:pokemon_clean_arch/modules/pokemon/presentation/bloc/pokemon_event.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_state.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6dd5ed), Color(0xFF2193b0)],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  "Clean Arch PokeAPI",
                  style: GoogleFonts.pressStart2p(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                centerTitle: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),
                    TextField(
                      controller: textController,
                      style: GoogleFonts.lato(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nome do Pokémon',
                        labelStyle: GoogleFonts.lato(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withAlpha((0.2 * 255).round()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.white54,
                            width: 1,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            bloc.add(SearchPokemonEvent(textController.text));
                          },
                        ),
                      ),
                      onSubmitted: (value) {
                        bloc.add(SearchPokemonEvent(value));
                      },
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        bloc.add(SearchPokemonEvent(textController.text));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf7b731),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Buscar Pokémon",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    BlocBuilder<PokemonBloc, PokemonState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _buildStateWidget(state),
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStateWidget(PokemonState state) {
    Key key;
    Widget content;

    switch (state) {
      case PokemonInitialState():
        key = const ValueKey('initial');
        content = _buildInfoCard(
          child: Column(
            children: [
              Icon(
                Icons.catching_pokemon,
                size: 80,
                color: Colors.blue.shade800,
              ),
              const SizedBox(height: 16),
              Text(
                "Comece sua jornada Pokémon!",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.blue.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        break;

      case PokemonLoadingState():
        key = const ValueKey('loading');
        content = _buildInfoCard(
          child: Column(
            children: [
              CircularProgressIndicator(color: Colors.blue.shade700),
              const SizedBox(height: 16),
              Text(
                "Procurando na Pokédex...",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
        );
        break;

      case PokemonErrorState(message: var msg):
        key = const ValueKey('error');
        content = _buildInfoCard(
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade700),
              const SizedBox(height: 16),
              Text(
                msg,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.red.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
        break;

      case PokemonSuccessState(pokemon: var p):
        key = ValueKey(p.id);
        content = _buildPokemonCard(p);
        break;
    }
    return SizedBox(key: key, child: content);
  }

  Widget _buildInfoCard({required Widget child}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white.withAlpha((0.9 * 255).round()),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildPokemonCard(PokemonEntity pokemon) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.red.shade400, Colors.blue.shade300],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withAlpha((0.3 * 255).round()),
                child: Image.network(
                  pokemon.imageUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                pokemon.name.toUpperCase(),
                style: GoogleFonts.pressStart2p(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withAlpha((0.5 * 255).round()),
                      offset: const Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'ID: #${pokemon.id.toString().padLeft(3, '0')}',
                style: GoogleFonts.lato(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
