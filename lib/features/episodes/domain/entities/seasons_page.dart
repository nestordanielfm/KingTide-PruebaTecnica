import 'package:equatable/equatable.dart';
import 'package:template_app/features/episodes/domain/entities/season.dart';

class SeasonsPage extends Equatable {
  final List<Season> items;
  final int total;
  final int page;
  final int size;
  final int pages;

  const SeasonsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  bool get hasMore => page < pages;

  @override
  List<Object?> get props => [items, total, page, size, pages];
}
