import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/episode_detail/data/models/episode_detail_model.dart';

part 'omdb_api.g.dart';

@RestApi()
abstract class OmdbApi {
  factory OmdbApi(Dio dio, {String? baseUrl}) = _OmdbApi;

  @GET('/')
  Future<EpisodeDetailModel> getEpisodeDetail({
    @Query('apikey') required String apiKey,
    @Query('t') required String title,
    @Query('Season') required int season,
    @Query('Episode') required int episode,
  });
}
