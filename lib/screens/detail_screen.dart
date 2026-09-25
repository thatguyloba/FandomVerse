import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/content_models.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_widgets.dart';

class TitleDetailScreen extends StatelessWidget {
  const TitleDetailScreen({super.key, required this.title, required this.app});

  final FandomTitle title;
  final AppController app;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 330,
            pinned: true,
            backgroundColor: AppColors.ink,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton.filledTonal(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            actions: [
              AnimatedBuilder(
                animation: app,
                builder: (context, _) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: AnimatedLikeButton(
                    selected: app.isBookmarked(title.id),
                    onTap: () => app.toggleBookmark(title.id),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Padding(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                child: Hero(
                  tag: 'art_${title.id}',
                  child: FandomArtwork(title: title, height: 290, showTitle: false),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 34),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(title.type.toUpperCase(), style: TextStyle(color: title.accent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4)),
                const SizedBox(height: 7),
                Text(title.name, style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 9),
                Text(title.description, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 21),
                Row(
                  children: [
                    _Metric(label: 'VERSE SCORE', value: '${title.score}', icon: Icons.star_rounded, color: AppColors.yellow),
                    const SizedBox(width: 10),
                    _Metric(label: 'EPISODES', value: '${title.episodes}', icon: Icons.play_circle_outline_rounded, color: AppColors.mint),
                    const SizedBox(width: 10),
                    _Metric(label: 'STATUS', value: title.meta.split(' · ').last, icon: Icons.bolt_rounded, color: title.accent),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added ${title.name} to your watchlist.'))),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start exploring'),
                  ),
                ),
                const SizedBox(height: 30),
                const SectionHeader(title: 'Lore drops'),
                const SizedBox(height: 14),
                _LoreDrop(
                  number: '01',
                  title: 'The detail fans keep missing',
                  body: 'A quick, spoiler-aware guide to the symbols, themes and tiny clues that make this universe worth revisiting.',
                  color: title.accent,
                ),
                const SizedBox(height: 12),
                _LoreDrop(
                  number: '02',
                  title: 'Build your theory board',
                  body: 'Save the moments that made you pause, then compare your take with the community when you are ready.',
                  color: AppColors.lavender,
                ),
                const SizedBox(height: 30),
                const SectionHeader(title: 'You might also like'),
                const SizedBox(height: 14),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final related = demoTitles[(demoTitles.indexOf(title) + index + 1) % demoTitles.length];
                      return SizedBox(
                        width: 152,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => Navigator.of(context).pushReplacement(FandomPageRoute(child: TitleDetailScreen(title: related, app: app))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: FandomArtwork(title: related, compact: true)),
                              const SizedBox(height: 8),
                              Text(related.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                              Text(related.type, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon, required this.color});

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 17),
            const SizedBox(height: 8),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.6)),
          ],
        ),
      ),
    );
  }
}

class _LoreDrop extends StatelessWidget {
  const _LoreDrop({required this.number, required this.title, required this.body, required this.color});

  final String number;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color.withOpacity(0.18), shape: BoxShape.circle),
            child: Text(number, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(body),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final FandomEvent event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 198,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(colors: [event.accent, AppColors.surfaceRaised]),
              ),
              child: Stack(
                children: [
                  Positioned(right: 16, top: 12, child: Icon(Icons.public_rounded, size: 160, color: Colors.white.withOpacity(0.16))),
                  Positioned(left: 22, bottom: 22, child: Text(event.month, style: const TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 3))),
                  Positioned(left: 20, top: 20, child: Text(event.date, style: const TextStyle(color: AppColors.ink, fontSize: 74, fontWeight: FontWeight.w900, height: 0.9))),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Text('UPCOMING EVENT', style: TextStyle(color: event.accent, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            const SizedBox(height: 7),
            Text(event.name, style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 9),
            Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 18), const SizedBox(width: 7), Expanded(child: Text(event.location))]),
            const SizedBox(height: 24),
            Text(event.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                children: [
                  const _EventInfoRow(icon: Icons.access_time_rounded, title: 'Time', value: '10:00 AM – 9:00 PM'),
                  const Divider(color: AppColors.line, height: 25),
                  const _EventInfoRow(icon: Icons.people_outline_rounded, title: 'Going', value: '1.2k fans already joined'),
                  const Divider(color: AppColors.line, height: 25),
                  const _EventInfoRow(icon: Icons.confirmation_num_outlined, title: 'Entry', value: 'Tickets from ₦5,000'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 54, child: FilledButton.icon(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You are on the list. Event reminders enabled.'))), icon: const Icon(Icons.event_available_rounded), label: const Text('Save my spot'))),
          ],
        ),
      ),
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  const _EventInfoRow({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.lavender, size: 21),
        const SizedBox(width: 13),
        Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(color: AppColors.text, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
