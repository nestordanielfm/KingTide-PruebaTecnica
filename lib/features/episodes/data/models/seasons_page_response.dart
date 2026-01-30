import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/episodes/data/models/season_response.dart';
import 'package:template_app/features/episodes/domain/entities/seasons_page.dart';

part 'seasons_page_response.g.dart';

@JsonSerializable()
class SeasonsPageResponse {
  final List<SeasonResponse> items;
  final int total;
  final int page;
  final int size;
  final int pages;

  SeasonsPageResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  factory SeasonsPageResponse.fromJson(Map<String, dynamic> json) =>
      _$SeasonsPageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonsPageResponseToJson(this);

  SeasonsPage toEntity() {
    return SeasonsPage(
      items: items.map((e) => e.toEntity()).toList(),
      total: total,
      page: page,
      size: size,
      pages: pages,
    );
  }
}
