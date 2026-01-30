import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/characters/data/models/characters_page_response.dart';

part 'characters_api.g.dart';

@RestApi()
abstract class CharactersApi {
  factory CharactersApi(Dio dio, {String? baseUrl}) = _CharactersApi;

  @GET('/characters')
  Future<CharactersPageResponse> getCharacters({
    @Query('orderBy') String orderBy = 'id',
    @Query('orderByDirection') String orderByDirection = 'asc',
    @Query('page') required int page,
    @Query('size') int size = 10,
    @Query('gender') String? gender,
    @Query('status') String? status,
    @Query('species') String? species,
  });
}
