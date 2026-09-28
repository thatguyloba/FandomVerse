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
    required this.image,
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
  final String image;
}

class NewsStory {
  const NewsStory({
    required this.title,
    required this.category,
    required this.readTime,
    required this.accent,
    required this.icon,
    required this.image,
  });

  final String title;
  final String category;
  final String readTime;
  final Color accent;
  final IconData icon;
  final String image;
}

class FandomEvent {
  const FandomEvent({
    required this.name,
    required this.location,
    required this.date,
    required this.month,
    required this.accent,
    required this.description,
    required this.image,
  });

  final String name;
  final String location;
  final String date;
  final String month;
  final Color accent;
  final String description;
  final String image;
}

class MerchItem {
  const MerchItem({
    required this.name,
    required this.price,
    required this.category,
    required this.accent,
    required this.icon,
    required this.image,
  });

  final String name;
  final String price;
  final String category;
  final Color accent;
  final IconData icon;
  final String image;
}
