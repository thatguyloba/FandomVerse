import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/content_models.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_logo.dart';
import '../widgets/fandom_widgets.dart';
import 'detail_screen.dart';
import 'store_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.app});

  final AppController app;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _heroController;
  int _heroIndex = 0;

  @override
  void initState() {
    super.initState();
    _heroController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  void _openTitle(FandomTitle title) {
    Navigator.of(context).push(FandomPageRoute(child: TitleDetailScreen(title: title, app: widget.app)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(child: _Header(app: widget.app)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            sliver: SliverToBoxAdapter(child: _WelcomeBlock(app: widget.app)),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 268,
              child: PageView.builder(
                controller: _heroController,
                itemCount: demoTitles.length,
                onPageChanged: (index) => setState(() => _heroIndex = index),
                itemBuilder: (context, index) {
                  final title = demoTitles[index];
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 20 : 7, right: 7, top: 22),
                    child: _HeroTitleCard(title: title, onTap: () => _openTitle(title)),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
            sliver: SliverToBoxAdapter(child: _PageDots(active: _heroIndex, count: demoTitles.length)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            sliver: SliverToBoxAdapter(child: const SectionHeader(title: 'Find your next obsession')),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterPill(label: 'All picks', selected: true, icon: Icons.auto_awesome_rounded),
                  _FilterPill(label: 'Anime', icon: Icons.play_circle_outline_rounded),
                  _FilterPill(label: 'Gaming', icon: Icons.sports_esports_outlined),
                  _FilterPill(label: 'Comics', icon: Icons.menu_book_outlined),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
            sliver: SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Continue exploring',
                action: 'See all',
                onTap: () => widget.app.changeTab(1),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 205,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                scrollDirection: Axis.horizontal,
                itemCount: demoTitles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 13),
                itemBuilder: (context, index) {
                  final title = demoTitles[index];
                  return SizedBox(
                    width: 166,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _openTitle(title),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 155,
                            child: Hero(
                              tag: 'art_${title.id}',
                              child: FandomArtwork(title: title, height: 155, compact: true),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(title.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Text(title.type, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            sliver: SliverToBoxAdapter(child: const SectionHeader(title: 'The fandom pulse')),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            sliver: SliverToBoxAdapter(child: _PulseCard()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            sliver: SliverToBoxAdapter(child: _EventPreview(onTap: () => _openEvent(context, demoEvents.first))),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
            sliver: SliverToBoxAdapter(child: _ShopPreview(onTap: () => Navigator.of(context).push(FandomPageRoute(child: StoreScreen(app: widget.app))))),
          ),
        ],
      ),
    );
  }

  void _openEvent(BuildContext context, FandomEvent event) {
    Navigator.of(context).push(FandomPageRoute(child: EventDetailScreen(event: event)));
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.app});
  final AppController app;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const FandomLogo(size: 38, showWordmark: true),
        const Spacer(),
        IconCircleButton(
          icon: Icons.notifications_none_rounded,
          badge: 2,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new transmissions right now.'))),
        ),
        const SizedBox(width: 10),
        AvatarBubble(
          initials: app.displayName.length > 1
              ? app.displayName.substring(0, 2).toUpperCase()
              : app.displayName.toUpperCase(),
          size: 44,
        ),
      ],
    );
  }
}

class _WelcomeBlock extends StatelessWidget {
  const _WelcomeBlock({required this.app});
  final AppController app;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good evening, ${app.displayName}.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 4),
        Text('What are we into today?', style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _HeroTitleCard extends StatelessWidget {
  const _HeroTitleCard({required this.title, required this.onTap});
  final FandomTitle title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'hero_${title.id}',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: title.secondaryAccent.withOpacity(0.16), blurRadius: 26, offset: const Offset(0, 14))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              fit: StackFit.expand,
              children: [
                FandomArtwork(title: title, showTitle: false),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.ink.withOpacity(0.92)],
                      stops: const [0.35, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 20,
                  bottom: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FEATURED UNIVERSE', style: TextStyle(color: title.secondaryAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
                            const SizedBox(height: 6),
                            Text(title.name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.7)),
                            const SizedBox(height: 3),
                            Text(title.tagline, style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(color: AppColors.lavender, shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_outward_rounded, color: AppColors.ink),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.active, required this.count});
  final int active;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == active ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: index == active ? AppColors.lavender : AppColors.line,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.icon, this.selected = false});
  final String label;
  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? AppColors.lavender : AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: selected ? AppColors.lavender : AppColors.line),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: selected ? AppColors.ink : AppColors.muted),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(color: selected ? AppColors.ink : AppColors.text, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PulseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      color: const Color(0xFF201D39),
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 15),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.pink.withOpacity(0.16), shape: BoxShape.circle),
            child: const Icon(Icons.bolt_rounded, color: AppColors.pink),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What the verse is talking about', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
                SizedBox(height: 4),
                Text('The Egghead finale, cozy games and villain arcs.', maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_rounded, color: AppColors.muted, size: 19),
        ],
      ),
    );
  }
}

class _EventPreview extends StatelessWidget {
  const _EventPreview({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final event = demoEvents.first;
    return GlassCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      color: event.accent.withOpacity(0.16),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 92,
            decoration: BoxDecoration(color: event.accent, borderRadius: BorderRadius.circular(22)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(event.date, style: const TextStyle(color: AppColors.ink, fontSize: 28, fontWeight: FontWeight.w900)),
                Text(event.month, style: const TextStyle(color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NEXT EVENT', style: TextStyle(color: AppColors.coral, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  const SizedBox(height: 6),
                  Text(event.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(event.location, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 15), child: Icon(Icons.chevron_right_rounded, color: AppColors.text)),
        ],
      ),
    );
  }
}

class _ShopPreview extends StatelessWidget {
  const _ShopPreview({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF3A2E62), Color(0xFF1D2442)]),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('VERSE MARKET', style: TextStyle(color: AppColors.mint, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.6)),
                  SizedBox(height: 7),
                  Text('Wear what you love.', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('Collectibles for every timeline.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 53,
              height: 53,
              decoration: const BoxDecoration(color: AppColors.mint, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_outlined, color: AppColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}
