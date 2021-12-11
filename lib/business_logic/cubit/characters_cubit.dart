import 'package:bloc/bloc.dart';
import '../../data/models/character.dart';
import '../../data/models/quote.dart';
import '../../data/repositories/charcters_repository.dart';
import 'package:meta/meta.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository charactersRepository;
  List<Character>? characters = [];
  CharactersCubit({required this.charactersRepository})
      : super(CharactersInitial());

  List<Character> getAllCharacters() {
    charactersRepository.getAllCharacters().then((characters) {
      emit(CharactersLoaded(characters: characters));
      this.characters = characters;
    });

    return characters!;
  }

  void getAllQuotes(String charName) {
    charactersRepository.getCharacterQoutes(charName).then((charQuotes) {
      emit(QuotesLoaded(quotes: charQuotes));
    });
  }
}
