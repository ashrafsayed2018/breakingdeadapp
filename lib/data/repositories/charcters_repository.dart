import '../models/character.dart';
import '../models/quote.dart';
import '../web_services/characters_web_services.dart';

class CharactersRepository {
  final CharacterWebServices characterWebServices;
  CharactersRepository(this.characterWebServices);

  Future<List<Character>> getAllCharacters() async {
    final characters = await characterWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getCharacterQoutes(String charName) async {
    final quotes = await characterWebServices.getCharacterQoutes(charName);
    return quotes.map((quote) => Quote.fromJson(quote)).toList();
  }
}
