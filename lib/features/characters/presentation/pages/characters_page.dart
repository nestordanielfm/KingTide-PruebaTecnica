import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/characters/presentation/store/characters_store.dart';
import 'package:template_app/features/characters/presentation/widgets/character_list_item.dart';
import 'package:template_app/features/characters/presentation/widgets/filters_section.dart';
import 'package:template_app/injection/injection.dart';

@RoutePage()
class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage>
    with AutomaticKeepAliveClientMixin {
  late final CharactersStore _store;
  late final ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _store = getIt<CharactersStore>();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    if (_store.characters.isEmpty && !_store.isLoading) {
      _store.loadCharacters();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _store.loadMoreCharacters();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          FiltersSection(store: _store),
          Expanded(
            child: Observer(
              builder: (context) {
                if (_store.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_store.isError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _store.failure?.message ?? 'Error loading characters',
                          style: const TextStyle(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _store.loadCharacters(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (_store.isEmpty) {
                  return const Center(
                    child: Text('No characters found with these filters'),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      _store.characters.length + (_store.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _store.characters.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final character = _store.characters[index];
                    return CharacterListItem(character: character);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
