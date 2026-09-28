import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/content_models.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_widgets.dart';
import 'detail_screen.dart';
import 'events_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, required this.app});

  final AppController app;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  int _selectedCategory = 0;

  final _categories = const ['Everything', 'Anime', 'Gaming', 'Comics'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FandomTitle> get _filteredTitles {
    final category = _categories[_selectedCategory];
    return demoTitles.where((title) {
      final matchesQuery = _query.trim().isEmpty ||
          title.name.toLowerCase().contains(_query.toLowerCase()) ||
          title.tagline.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = category == 'Everything' ||
          title.type.toLowerCase().contains(category.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                        Text('Discover',
                            style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 5),
                        const Text('Find the next world to get lost in.'),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                      onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search titles, lore, creators...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close_rounded)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 58,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(right: 9),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedCategory == index,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = index),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 27, 20, 0),
            sliver: SliverToBoxAdapter(
                child: const SectionHeader(title: 'Trending this week')),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 198,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: demoNews.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) =>
                    _NewsCard(story: demoNews[index]),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _EventsShortcut(
                onTap: () => Navigator.of(context)
                    .push(FandomPageRoute(child: const EventsScreen())),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            sliver: SliverToBoxAdapter(
                child: SectionHeader(
                    title: 'Explore titles',
                    action: '${_filteredTitles.length} found')),
          ),
          if (_filteredTitles.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No worlds found. Try a different signal.'))),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 34),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final title = _filteredTitles[index];
                    return _DiscoverTitleCard(
                      title: title,
                      isSaved: widget.app.isBookmarked(title.id),
                      onTap: () => Navigator.of(context).push(FandomPageRoute(
                          child: TitleDetailScreen(
                              title: title, app: widget.app))),
                      onSave: () => widget.app.toggleBookmark(title.id),
                    );
                  },
                  childCount: _filteredTitles.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 13,
                  childAspectRatio: 0.68,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EventsShortcut extends StatelessWidget {
  const _EventsShortcut({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      color: AppColors.mint.withOpacity(0.12),
      child: Row(
        children: [
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: AppColors.mint.withOpacity(0.18),
                  shape: BoxShape.circle),
              child: const Icon(Icons.event_available_rounded,
                  color: AppColors.mint)),
          const SizedBox(width: 12),
          const Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('Find your next fandom event',
                    style: TextStyle(
                        color: AppColors.text, fontWeight: FontWeight.w700)),
                SizedBox(height: 3),
                Text('Conventions, panels and creator nights near you.',
                    maxLines: 1, overflow: TextOverflow.ellipsis)
              ])),
          const Icon(Icons.arrow_forward_rounded,
              color: AppColors.mint, size: 19),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.story});

  final NewsStory story;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        image: DecorationImage(image: AssetImage(story.image), fit: BoxFit.cover),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [story.accent.withOpacity(0.82), AppColors.surfaceRaised]),
      ),
      child: Stack(
        children: [
          Image.network(
            story.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const ColoredBox(
              color: AppColors.inkSoft,
              child: Center(
                child: Icon(Icons.broken_image_outlined,
                    color: Color(0xB3FFFFFF), size: 34),
              ),
            ),
          ),
          Positioned(
              right: -14,
              top: -16,
              child: Icon(story.icon,
                  size: 100, color: Colors.white.withOpacity(0.13))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),
              Text(story.category,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.3)),
              const SizedBox(height: 8),
              Text(story.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.1)),
              const SizedBox(height: 12),
              Row(children: [
                const Icon(Icons.schedule_rounded,
                    color: Colors.white70, size: 14),
                const SizedBox(width: 5),
                Text(story.readTime,
                    style: const TextStyle(color: Colors.white70, fontSize: 11))
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

class _DiscoverTitleCard extends StatelessWidget {
  const _DiscoverTitleCard(
      {required this.title,
      required this.isSaved,
      required this.onTap,
      required this.onSave});

  final FandomTitle title;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(21),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Hero(
                    tag: 'discover_${title.id}',
                    child: FandomArtwork(title: title, compact: true)),
                Positioned(
                    top: 8,
                    right: 8,
                    child:
                        AnimatedLikeButton(selected: isSaved, onTap: onSave)),
              ],
            ),
          ),
          const SizedBox(height: 9),
          Text(title.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 3),
          Row(children: [
            const Icon(Icons.star_rounded, color: AppColors.yellow, size: 14),
            const SizedBox(width: 4),
            Text('${title.score}',
                style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700))
          ]),
        ],
      ),
    );
  }
}
