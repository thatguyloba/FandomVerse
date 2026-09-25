import 'package:flutter/material.dart';

class FandomTitle {
  const FandomTitle({
    required this.id,
    required this.name,
    required this.type,
    required this.tagline,
    required this.description,
    required this.accent,
    required this.secondaryAccent,
    required this.icon,
    required this.score,
    required this.meta,
    required this.episodes,
  });

  final String id;
  final String name;
  final String type;
  final String tagline;
  final String description;
  final Color accent;
  final Color secondaryAccent;
  final IconData icon;
  final double score;
  final String meta;
  final int episodes;
}

class NewsStory {
  const NewsStory({
    required this.title,
    required this.category,
    required this.readTime,
    required this.accent,
    required this.icon,
  });

  final String title;
  final String category;
  final String readTime;
  final Color accent;
  final IconData icon;
}

class FandomEvent {
  const FandomEvent({
    required this.name,
    required this.location,
    required this.date,
    required this.month,
    required this.accent,
    required this.description,
  });

  final String name;
  final String location;
  final String date;
  final String month;
  final Color accent;
  final String description;
}

class MerchItem {
  const MerchItem({
    required this.name,
    required this.price,
    required this.category,
    required this.accent,
    required this.icon,
  });

  final String name;
  final String price;
  final String category;
  final Color accent;
  final IconData icon;
}
