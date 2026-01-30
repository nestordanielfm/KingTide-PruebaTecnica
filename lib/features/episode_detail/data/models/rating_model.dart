import 'package:json_annotation/json_annotation.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel {
  @JsonKey(name: 'Source')
  final String source;

  @JsonKey(name: 'Value')
  final String value;

  const RatingModel({required this.source, required this.value});

  factory RatingModel.fromJson(Map<String, dynamic> json) =>
      _$RatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingModelToJson(this);
}
