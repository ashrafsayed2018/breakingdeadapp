import 'business_logic/cubit/characters_cubit.dart';
import 'constants/string.dart';
import 'data/models/character.dart';
import 'data/repositories/charcters_repository.dart';
import 'data/web_services/characters_web_services.dart';
import 'presentation/screens/characters_screen.dart';
import 'presentation/screens/charcter_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersRepository = CharactersRepository(CharacterWebServices());

    charactersCubit =
        CharactersCubit(charactersRepository: charactersRepository);
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charactersScreenRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => charactersCubit,
            child: const CharactersScreen(),
          ),
        );

      case characterDetailsScreenRoute:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                CharactersCubit(charactersRepository: charactersRepository),
            child: CharacterDetailsScreen(
              character: character,
            ),
          ),
        );
    }
  }
}
