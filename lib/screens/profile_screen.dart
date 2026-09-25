import 'package:flutter/material.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_logo.dart';
import '../widgets/fandom_widgets.dart';
import 'admin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.app});

  final AppController app;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _spoilerSafe = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 23, 20, 0),
            sliver: SliverToBoxAdapter(child: Row(children: [Text('Profile', style: Theme.of(context).textTheme.displayMedium), const Spacer(), const FandomLogo(size: 34)])),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
            sliver: SliverToBoxAdapter(child: _ProfileCard(app: widget.app)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            sliver: SliverToBoxAdapter(child: const SectionHeader(title: 'Your interests')),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  Chip(avatar: Icon(Icons.play_circle_outline_rounded, size: 16), label: Text('Anime')),
                  Chip(avatar: Icon(Icons.sports_esports_outlined, size: 16), label: Text('Gaming')),
                  Chip(avatar: Icon(Icons.menu_book_outlined, size: 16), label: Text('Comics')),
                  Chip(avatar: Icon(Icons.movie_outlined, size: 16), label: Text('Movies')),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            sliver: SliverToBoxAdapter(child: const SectionHeader(title: 'Preferences')),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(
              child: GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _PreferenceTile(icon: Icons.notifications_none_rounded, title: 'Fandom alerts', subtitle: 'Drops, events and community updates', value: _notifications, onChanged: (value) => setState(() => _notifications = value)),
                    const Divider(height: 1, color: AppColors.line),
                    _PreferenceTile(icon: Icons.visibility_outlined, title: 'Spoiler-safe feed', subtitle: 'Keep major reveals behind a tap', value: _spoilerSafe, onChanged: (value) => setState(() => _spoilerSafe = value)),
                    const Divider(height: 1, color: AppColors.line),
                    _PreferenceTile(icon: Icons.language_rounded, title: 'Language', subtitle: 'English', trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted)),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            sliver: SliverToBoxAdapter(
              child: GlassCard(
                onTap: () => Navigator.of(context).push(FandomPageRoute(child: const AdminScreen())),
                color: AppColors.lavender.withOpacity(0.10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: const Row(
                  children: [
                    Icon(Icons.dashboard_customize_outlined, color: AppColors.lavender),
                    SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Creator studio', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)), SizedBox(height: 3), Text('Moderate drops and events', style: TextStyle(color: AppColors.muted, fontSize: 12))])),
                    Icon(Icons.chevron_right_rounded, color: AppColors.muted),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            sliver: SliverToBoxAdapter(
              child: OutlinedButton.icon(
                onPressed: widget.app.signOut,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.coral, side: BorderSide(color: AppColors.coral.withOpacity(0.4)), minimumSize: const Size.fromHeight(52)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.app});
  final AppController app;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          const AvatarBubble(initials: 'AD', size: 68),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.displayName, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 4),
                const Text('Explorer level · 07'),
                const SizedBox(height: 13),
                Row(children: [const Icon(Icons.bookmark_rounded, color: AppColors.lavender, size: 16), const SizedBox(width: 5), Text(app.savedLabel, style: const TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w700)), const SizedBox(width: 15), const Icon(Icons.bolt_rounded, color: AppColors.coral, size: 16), const SizedBox(width: 5), const Text('1.8k XP', style: TextStyle(color: AppColors.text, fontSize: 12, fontWeight: FontWeight.w700))]),
              ],
            ),
          ),
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile editing is ready for your account backend.'))), icon: const Icon(Icons.edit_outlined, color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  const _PreferenceTile({required this.icon, required this.title, required this.subtitle, this.value, this.onChanged, this.trailing});

  final IconData icon;
  final String title;
  final String subtitle;
  final bool? value;
  final ValueChanged<bool>? onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.13), shape: BoxShape.circle), child: Icon(icon, color: AppColors.lavender, size: 19)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(subtitle, style: Theme.of(context).textTheme.labelMedium)])),
          if (onChanged != null) Switch(value: value ?? false, onChanged: onChanged) else if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
