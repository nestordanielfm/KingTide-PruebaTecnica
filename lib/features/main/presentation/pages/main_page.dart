import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:template_app/core/theme/app_theme.dart';
import 'package:template_app/features/characters/presentation/pages/characters_page.dart';
import 'package:template_app/features/episodes/presentation/pages/episodes_page.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Futurama'),
          centerTitle: true,
          elevation: 2,
        ),
        body: const TabBarView(children: [EpisodesPage(), CharactersPage()]),
        bottomNavigationBar: Container(
          color: Theme.of(context).appBarTheme.backgroundColor,
          child: const TabBar(
            labelStyle: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(icon: Icon(Icons.video_library), text: 'Episodes'),
              Tab(icon: Icon(Icons.people), text: 'Characters'),
            ],
          ),
        ),
      ),
    );
  }
}
