import 'dart:io';

import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../theme/app_theme.dart';
import 'fandom_logo.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.color,
    this.borderRadius = 24,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final double borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface.withOpacity(0.92),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {super.key, required this.title, this.action, this.onTap});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (action != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.lavender,
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(action!),
          ),
      ],
    );
  }
}

class IconCircleButton extends StatelessWidget {
  const IconCircleButton(
      {super.key, required this.icon, this.onTap, this.badge});

  final IconData icon;
  final VoidCallback? onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: AppColors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 46,
              height: 46,
              child: Icon(icon, color: AppColors.text, size: 20),
            ),
          ),
        ),
        if (badge != null && badge! > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.coral,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class FandomArtwork extends StatelessWidget {
  const FandomArtwork({
    super.key,
    required this.title,
    this.height,
    this.showTitle = true,
    this.compact = false,
  });

  final FandomTitle title;
  final double? height;
  final bool showTitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(decoration: BoxDecoration(color: title.accent)),
        Image.network(
          title.image,
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
          top: -34,
          right: -20,
          child: _ArtworkOrb(
              size: compact ? 130 : 220, color: Colors.white.withOpacity(0.17)),
        ),
        Positioned(
          bottom: compact ? -30 : -54,
          left: compact ? -20 : -35,
          child: _ArtworkOrb(
              size: compact ? 110 : 190, color: Colors.black.withOpacity(0.14)),
        ),
        Positioned(
          top: compact ? 20 : 34,
          right: compact ? 18 : 28,
          child: Icon(title.icon,
              size: compact ? 58 : 94, color: Colors.white.withOpacity(0.82)),
        ),
        Positioned(
          top: compact ? 26 : 48,
          left: compact ? 18 : 28,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.24),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              title.type.split(' · ').first.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
              ),
            ),
          ),
        ),
        if (showTitle)
          Positioned(
            left: compact ? 18 : 28,
            right: compact ? 14 : 24,
            bottom: compact ? 16 : 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 16 : 25,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  title.tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: compact ? 10 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 20 : 28),
      child: SizedBox(height: height ?? (compact ? 175 : 230), child: content),
    );
  }
}

class _ArtworkOrb extends StatelessWidget {
  const _ArtworkOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.35), width: 1.4),
        color: color.withOpacity(0.28),
      ),
    );
  }
}

class EmptyLibrary extends StatelessWidget {
  const EmptyLibrary({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FandomLogo(size: 74),
            const SizedBox(height: 22),
            Text('Your shelf is waiting',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'Save anime, games and stories here so your next obsession is always one tap away.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onExplore,
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore the verse'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLikeButton extends StatelessWidget {
  const AnimatedLikeButton(
      {super.key, required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutBack,
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: selected ? AppColors.lavender : AppColors.surface,
        shape: BoxShape.circle,
        border:
            Border.all(color: selected ? AppColors.lavender : AppColors.line),
      ),
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            selected ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            key: ValueKey(selected),
            size: 19,
            color: selected ? AppColors.ink : AppColors.text,
          ),
        ),
      ),
    );
  }
}

class AvatarBubble extends StatelessWidget {
  const AvatarBubble({super.key, this.initials = 'AD', this.size = 44});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.coral, AppColors.pink, AppColors.lavender],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.ink,
          fontSize: size * 0.29,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
