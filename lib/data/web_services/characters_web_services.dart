import '../../constants/string.dart';
import 'package:dio/dio.dart';

class CharacterWebServices {
  late Dio dio;

  CharacterWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: false,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get("characters");

      return response.data;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getCharacterQoutes(String charName) async {
    try {
      Response response = await dio.get(
        "quote",
        queryParameters: {'author': charName},
      );

      return response.data;
    } catch (e) {
      return [];
    }
  }
}
