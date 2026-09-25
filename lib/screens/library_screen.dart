import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/content_models.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_widgets.dart';
import 'detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key, required this.app});

  final AppController app;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) {
        final titles = demoTitles.where((title) => app.bookmarks.contains(title.id)).toList();
        return SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your library', style: Theme.of(context).textTheme.displayMedium),
                            const SizedBox(height: 5),
                            Text(app.savedLabel),
                          ],
                        ),
                      ),
                      IconCircleButton(icon: Icons.sort_rounded, onTap: () {}),
                    ],
                  ),
                ),
              ),
              if (titles.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyLibrary(onExplore: () => app.changeTab(1)),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 27, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _LibrarySummary(count: titles.length),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final title = titles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: _SavedTitleTile(
                            title: title,
                            onTap: () => Navigator.of(context).push(FandomPageRoute(child: TitleDetailScreen(title: title, app: app))),
                            onRemove: () => app.toggleBookmark(title.id),
                          ),
                        );
                      },
                      childCount: titles.length,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

}

class _LibrarySummary extends StatelessWidget {
  const _LibrarySummary({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF2D2354), Color(0xFF1B203F)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.lavender, size: 24),
          const SizedBox(width: 13),
          Expanded(child: Text('$count worlds are ready when you are.', style: Theme.of(context).textTheme.titleMedium)),
          const Icon(Icons.arrow_forward_rounded, color: AppColors.muted, size: 19),
        ],
      ),
    );
  }
}

class _SavedTitleTile extends StatelessWidget {
  const _SavedTitleTile({required this.title, required this.onTap, required this.onRemove});

  final FandomTitle title;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(width: 82, height: 82, child: FandomArtwork(title: title, compact: true)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(title.type, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 9),
                Row(children: [const Icon(Icons.star_rounded, size: 14, color: AppColors.yellow), const SizedBox(width: 4), Text('${title.score}', style: const TextStyle(color: AppColors.muted, fontSize: 12)), const SizedBox(width: 12), Text(title.meta, style: const TextStyle(color: AppColors.muted, fontSize: 11))]),
              ],
            ),
          ),
          IconButton(onPressed: onRemove, icon: const Icon(Icons.bookmark_rounded, color: AppColors.lavender)),
        ],
      ),
    );
  }
}
