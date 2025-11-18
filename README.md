# Pokémon App
App que demonstra Clean Architecture no Flutter, consumindo a PokeAPI para exibir dados de Pokémons. O projeto simula a alta exigência de manutenibilidade e rastreabilidade de código necessárias em aplicações de e-commerce, utilizando o padrão BLoC e Injeção de Dependência em tempo de compilação.

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

# Features
- [x] Busca de Pokémon (consumo de API)

# Screenshot
<br>![exemplo](https://i.imgur.com/zJIGo3l.png)

# TO DO
O projeto atinge seu objetivo arquitetural. Os próximos passos focariam em estabilização e qualidade de código:
[ ] Testes Unitários de Use Case com mocktail (Conceito pronto, implementação em andamento)
[ ] Testes de Widget (Golden Tests para UI)
[ ] Implementação de Cache/Persistência Local para o Catalog (e-commerce real)
[ ] Implementação de CI/CD Pipeline
[ ] Adaptação para o padrão White Label (mudar cores/temas dinamicamente)
