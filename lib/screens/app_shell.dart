import 'package:flutter/material.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_logo.dart';
import 'assistant_screen.dart';
import 'discover_screen.dart';
import 'home_screen.dart';
import 'library_screen.dart';
import 'profile_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.app});

  final AppController app;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: app.selectedTab,
            children: [
              HomeScreen(app: app),
              DiscoverScreen(app: app),
              LibraryScreen(app: app),
              ProfileScreen(app: app),
            ],
          ),
          floatingActionButton: app.selectedTab == 0 || app.selectedTab == 1
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: FloatingActionButton(
                    heroTag: 'verse-guide-fab',
                    onPressed: () => Navigator.of(context).push(FandomPageRoute(child: const AssistantScreen())),
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.ink,
                    child: const FandomLogo(size: 25),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: NavigationBar(
            selectedIndex: app.selectedTab,
            onDestinationSelected: app.changeTab,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore_rounded), label: 'Discover'),
              NavigationDestination(icon: Icon(Icons.bookmark_border_rounded), selectedIcon: Icon(Icons.bookmark_rounded), label: 'Library'),
              NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
