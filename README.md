# Pokémon App

![Flutter CI](https://github.com/ruanhcr/pokemon_clean_arch/actions/workflows/flutter_ci.yml/badge.svg)

App que demonstra Clean Architecture no Flutter para mobile multiplataforma (Android & iOS), consumindo a PokeAPI para exibir dados de Pokémons. O projeto simula a alta exigência de manutenibilidade e rastreabilidade de código, utilizando o padrão BLoC, Injeção de Dependência em tempo de compilação e Programação funcional (fpdart).

# Config
O projeto utiliza Code Generation para o sistema de Injeção de Dependência (injectable). Para a execução correta, é necessário rodar o build_runner.
Clone o repositório.
Obtenha as dependências: flutter pub get
Execute o gerador de código no terminal (na raiz do projeto): dart run build_runner build --delete-conflicting-outputs

# Development Roadmap
- [x] Clean Architecture (Domain, Data, Presentation)
- [x] Princípios SOLID e SRP (Single Responsibility Principle)
- [x] BLoC Pattern (Eventos, Estados e Fluxo Unidirecional)
- [x] Service Locator (GetIt)
- [x] Code Generation para Injeção de Dependência (Injectable)
- [x] Repository Pattern e Use Cases
- [x] [Flutter/Dart](https://docs.flutter.dev)
- [x] [Flutter Bloc](https://pub.dev/packages/flutter_bloc) 
- [x] [get_it](https://pub.dev/packages/get_it)
- [x] [Injectable](https://pub.dev/packages/injectable)
- [x] [Go Router](https://pub.dev/packages/go_router)
- [x] [Dio](https://pub.dev/packages/dio)
- [x] [Equatable](https://pub.dev/packages/equatable)
- [x] [fpdart](https://pub.dev/packages/fpdart)
- [x] [Hive](https://pub.dev/packages/hive)
- [x] Testes unitários, testes de widget e testes de integração
- [x] DevOps: CI/CD com GitHub Actions

# Features
- [x] Lista de Pokémon (consumo de API)
- [x] Busca de Pokémon (consumo de API)
- [x] Detalhes de Pokémon (consumo de API)
- [x] Adição/Subtração de Pokémon Favorito (Cache local)
- [x] Lista de Favoritos (Cache local)

# Screenshots
<br>![exemplo](https://i.imgur.com/Z3y7HT9.jpeg)
<br>![exemplo](https://i.imgur.com/Po8sp9r.jpeg)
<br>![exemplo](https://i.imgur.com/11UwRIH.jpeg)
<br>![exemplo](https://i.imgur.com/nXBeiUf.png)
<br>![exemplo](https://i.imgur.com/UcTeCe3.png)

