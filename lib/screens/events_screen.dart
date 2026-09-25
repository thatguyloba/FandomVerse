import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/content_models.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_widgets.dart';
import 'detail_screen.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fandom events'),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Meet your people.', style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 7),
                  const Text('Find conventions, creator nights and game events near your timeline.'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
            sliver: SliverToBoxAdapter(child: Row(children: [const Icon(Icons.near_me_rounded, color: AppColors.mint, size: 18), const SizedBox(width: 7), const Text('Lagos · showing nearby events'), const Spacer(), TextButton(onPressed: () {}, child: const Text('Change'))])),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final event = demoEvents[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: _EventListTile(event: event, onTap: () => Navigator.of(context).push(FandomPageRoute(child: EventDetailScreen(event: event)))),
                  );
                },
                childCount: demoEvents.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventListTile extends StatelessWidget {
  const _EventListTile({required this.event, required this.onTap});

  final FandomEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 78,
            decoration: BoxDecoration(color: event.accent.withOpacity(0.88), borderRadius: BorderRadius.circular(19)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(event.date, style: const TextStyle(color: AppColors.ink, fontSize: 25, fontWeight: FontWeight.w900)), Text(event.month, style: const TextStyle(color: AppColors.ink, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.1))]),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 15), const SizedBox(width: 4), Expanded(child: Text(event.location, maxLines: 1, overflow: TextOverflow.ellipsis))]),
                const SizedBox(height: 8),
                Row(children: [Icon(Icons.people_outline_rounded, color: event.accent, size: 15), const SizedBox(width: 4), const Text('1.2k fans going', style: TextStyle(color: AppColors.muted, fontSize: 11))]),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}
