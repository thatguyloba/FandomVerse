import 'package:flutter/material.dart';
import '../data/demo_data.dart';
import '../models/content_models.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/fandom_widgets.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key, required this.app});

  final AppController app;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verse Market'),
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back_rounded)),
        actions: [
          AnimatedBuilder(
            animation: app,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconCircleButton(icon: Icons.shopping_bag_outlined, badge: app.cart.length, onTap: () => _showCart(context)),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            sliver: SliverToBoxAdapter(child: _StoreBanner()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 27, 20, 0),
            sliver: SliverToBoxAdapter(child: const SectionHeader(title: 'Fresh from the portal')),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _MerchCard(item: demoMerch[index], app: app),
                childCount: demoMerch.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 13,
                childAspectRatio: 0.70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCart(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
        child: AnimatedBuilder(
          animation: app,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your bag', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(app.cart.isEmpty ? 'Your bag is waiting for a little magic.' : '${app.cart.length} collectible(s) ready to checkout.'),
              const SizedBox(height: 20),
              if (app.cart.isNotEmpty)
                SizedBox(width: double.infinity, height: 52, child: FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Continue to checkout'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoreBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      height: 148,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.pink, AppColors.lavender, Color(0xFF4A3C77)]),
      ),
      child: Stack(
        children: [
          Positioned(right: -20, top: -32, child: Icon(Icons.auto_awesome_rounded, size: 170, color: Colors.white.withOpacity(0.16))),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WEAR YOUR LORE', style: TextStyle(color: AppColors.ink, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              SizedBox(height: 9),
              Text('Collect a piece\nof your universe.', style: TextStyle(color: AppColors.ink, fontSize: 22, fontWeight: FontWeight.w900, height: 1.0)),
              SizedBox(height: 10),
              Text('Small-batch drops · Fan-made energy', style: TextStyle(color: AppColors.ink, fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MerchCard extends StatelessWidget {
  const _MerchCard({required this.item, required this.app});

  final MerchItem item;
  final AppController app;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      onTap: () => _add(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: item.accent.withOpacity(0.19),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(right: -10, top: -12, child: Icon(item.icon, size: 100, color: item.accent.withOpacity(0.30))),
                  Center(child: Icon(item.icon, color: item.accent, size: 52)),
                  Positioned(top: 10, left: 10, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: AppColors.ink.withOpacity(0.42), borderRadius: BorderRadius.circular(100)), child: Text(item.category, style: const TextStyle(color: AppColors.text, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.8)))),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Row(children: [Expanded(child: Text(item.price, style: const TextStyle(color: AppColors.lavender, fontWeight: FontWeight.w800, fontSize: 13))), const Icon(Icons.add_circle_outline_rounded, color: AppColors.muted, size: 19)]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _add(BuildContext context) {
    app.addToCart(item.name);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} added to your bag.')));
  }
}
