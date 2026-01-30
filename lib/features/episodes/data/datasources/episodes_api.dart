import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/episodes/data/models/seasons_page_response.dart';

part 'episodes_api.g.dart';

@RestApi()
abstract class EpisodesApi {
  factory EpisodesApi(Dio dio, {String? baseUrl}) = _EpisodesApi;

  @GET('/seasons')
  Future<SeasonsPageResponse> getSeasons(
    @Query('page') int page,
    @Query('size') int size,
  );
}
