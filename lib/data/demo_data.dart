import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../theme/app_theme.dart';

const demoTitles = <FandomTitle>[
  FandomTitle(
    id: 'one-piece',
    name: 'One Piece',
    type: 'Anime · Adventure',
    tagline: 'The sea is calling.',
    description:
        'Set sail with the Straw Hats and dive into the lore, islands and mysteries that make the Grand Line unforgettable.',
    accent: Color(0xFFFF9A72),
    secondaryAccent: Color(0xFFF05F8F),
    icon: Icons.sailing_rounded,
    score: 9.7,
    meta: 'Egghead Arc · Ongoing',
    episodes: 1122,
    image: 'assets/onePiece.jpeg',
  ),
  FandomTitle(
    id: 'death-note',
    name: 'Death Note',
    type: 'Anime · Psychological',
    tagline: 'Justice has a name.',
    description:
        'Explore the rules, rivalries and moral questions behind the legendary notebook that changed the supernatural thriller.',
    accent: Color(0xFF9B8CFF),
    secondaryAccent: Color(0xFF2B3467),
    icon: Icons.menu_book_rounded,
    score: 9.1,
    meta: '37 Episodes · Complete',
    episodes: 37,
    image: 'assets/deathNote.jpg',
  ),
  FandomTitle(
    id: 'hells-paradise',
    name: "Hell's Paradise",
    type: 'Anime · Dark fantasy',
    tagline: 'Paradise is a battlefield.',
    description:
        'Decode the island, the Tensen and the dangerous search for an elixir of immortality.',
    accent: Color(0xFF8AD9B9),
    secondaryAccent: Color(0xFF355A62),
    icon: Icons.local_florist_rounded,
    score: 8.6,
    meta: 'Season 1 · 13 Episodes',
    episodes: 13,
    image: 'assets/hellsParadise.png',
  ),
  FandomTitle(
    id: 'classroom-elite',
    name: 'Classroom of the Elite',
    type: 'Anime · Strategy',
    tagline: 'Read between the rules.',
    description:
        'A sharp dive into the classes, exams and psychological games of the Advanced Nurturing High School.',
    accent: Color(0xFFF4C879),
    secondaryAccent: Color(0xFF9D5D70),
    icon: Icons.school_rounded,
    score: 8.4,
    meta: 'Season 3 · 13 Episodes',
    episodes: 38,
    image: 'assets/classroom.jpg',
  ),
  FandomTitle(
    id: 'mashle',
    name: 'Mashle',
    type: 'Anime · Comedy',
    tagline: 'Muscles beat magic.',
    description: 'Track Mash Burnedead’s chaotic climb through a world where magic is everything and cream puffs are fuel.',
    accent: Color(0xFFB8A4FF),
    secondaryAccent: Color(0xFF7258AD),
    icon: Icons.auto_awesome_rounded,
    score: 8.0,
    meta: 'Season 2 · 12 Episodes',
    episodes: 24,
    image: 'assets/mashle.jpeg',
  ),
];
const demoNews = <NewsStory>[
  NewsStory(
    title: 'Why the next anime season feels like a golden age',
    category: 'EDITORIAL',
    readTime: '6 min read',
    accent: AppColors.pink,
    icon: Icons.auto_awesome_rounded,
    image: 'assets/anime.png',
  ),
  NewsStory(
    title: 'Seven game worlds worth getting lost in this weekend',
    category: 'GAMING',
    readTime: '4 min read',
    accent: AppColors.mint,
    icon: Icons.sports_esports_rounded,
    image: 'assets/gow.jpg',
  ),
  NewsStory(
    title: 'The art of building a universe fans never leave',
    category: 'CULTURE',
    readTime: '8 min read',
    accent: AppColors.coral,
    icon: Icons.public_rounded,
    image: 'assets/culture.jpg',
  ),
];

const demoEvents = <FandomEvent>[
  FandomEvent(
    name: 'Anime & Gaming Expo',
    location: 'Landmark Centre · Lagos',
    date: '18',
    month: 'OCT',
    accent: AppColors.pink,
    description: 'A weekend of cosplay, competitive gaming, creator panels and the newest stories from across the fandom universe.',
    image: 'assets/anime.png'
  ),
  FandomEvent(
    name: 'Comic Culture Night',
    location: 'The Works · Accra',
    date: '02',
    month: 'NOV',
    accent: AppColors.mint,
    description: 'Meet independent artists, trade rare issues and share the stories that made you fall in love with comics.',
    image: 'assets/culture.jpg'
  ),
  FandomEvent(
    name: 'Pixel Play Fest',
    location: 'Eko Convention Hall · Lagos',
    date: '21',
    month: 'DEC',
    accent: AppColors.yellow,
    description: 'A celebration of games, speed runs, tabletop worlds and the people who build them.',
    image: 'assets/hotel.jpg'
  ),
];

const demoMerch = <MerchItem>[
  MerchItem(
    name: 'Verse Signal Tee',
    price: '₦18,500',
    category: 'APPAREL',
    accent: AppColors.lavender,
    icon: Icons.checkroom_rounded,
    image: 'assets/Tee.jpg',
  ),
  MerchItem(
    name: 'Power-Up Enamel Pin',
    price: '₦6,900',
    category: 'COLLECTIBLE',
    accent: AppColors.coral,
    icon: Icons.bolt_rounded,
    image: 'assets/pin.jpg',
  ),
  MerchItem(
    name: 'Lore Keeper Journal',
    price: '₦11,200',
    category: 'STATIONERY',
    accent: AppColors.mint,
    icon: Icons.menu_book_rounded,
    image: 'assets/Journal.jpg',
  ),
  MerchItem(
    name: 'Portal Desk Mat',
    price: '₦24,500',
    category: 'DESK SETUP',
    accent: AppColors.pink,
    icon: Icons.grid_view_rounded,
    image: 'assets/Mat.jpg',
  ),
];
