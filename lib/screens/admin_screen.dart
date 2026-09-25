import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_widgets.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creator studio'),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded))],
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
                  Text('Keep the verse healthy.', style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 7),
                  const Text('Review content, publish drops and keep the community signal bright.'),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: const [
                  Expanded(child: _AdminMetric(value: '128', label: 'LIVE TITLES', icon: Icons.public_rounded, color: AppColors.lavender)),
                  SizedBox(width: 10),
                  Expanded(child: _AdminMetric(value: '24', label: 'EVENTS', icon: Icons.event_rounded, color: AppColors.mint)),
                  SizedBox(width: 10),
                  Expanded(child: _AdminMetric(value: '07', label: 'FLAGGED', icon: Icons.flag_outlined, color: AppColors.coral)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            sliver: SliverToBoxAdapter(child: const SectionHeader(title: 'Needs your signal', action: 'See all')),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            sliver: SliverToBoxAdapter(
              child: GlassCard(
                child: Column(
                  children: const [
                    _ModerationRow(icon: Icons.article_outlined, title: 'New lore article', subtitle: 'Submitted 12 min ago', color: AppColors.lavender),
                    Divider(color: AppColors.line, height: 24),
                    _ModerationRow(icon: Icons.report_gmailerrorred_outlined, title: 'Community report', subtitle: 'Spoiler tag missing · 2 reports', color: AppColors.coral),
                    Divider(color: AppColors.line, height: 24),
                    _ModerationRow(icon: Icons.event_outlined, title: 'Event awaiting publish', subtitle: 'Pixel Play Fest · Lagos', color: AppColors.mint),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Content composer is ready for Firestore integration.'))),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create a new drop'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminMetric extends StatelessWidget {
  const _AdminMetric({required this.value, required this.label, required this.icon, required this.color});

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(11, 13, 11, 12),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.line)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 19, color: color), const SizedBox(height: 11), Text(value, style: const TextStyle(color: AppColors.text, fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5))]),
    );
  }
}

class _ModerationRow extends StatelessWidget {
  const _ModerationRow({required this.icon, required this.title, required this.subtitle, required this.color});

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle), child: Icon(icon, color: color, size: 19)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(subtitle, style: Theme.of(context).textTheme.labelMedium)])), const Icon(Icons.chevron_right_rounded, color: AppColors.muted)]);
  }
}
