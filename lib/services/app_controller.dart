import 'package:flutter/foundation.dart';
import '../data/demo_data.dart';

class AppController extends ChangeNotifier {
  bool isAuthenticated = false;
  int selectedTab = 0;
  String displayName = 'Aiden';
  final Set<String> bookmarks = {'one-piece', 'death-note'};
  final Set<String> cart = <String>{};

  void signIn({String? name}) {
    isAuthenticated = true;
    if (name != null && name.trim().isNotEmpty) {
      displayName = name.trim();
    }
    notifyListeners();
  }

  void signOut() {
    isAuthenticated = false;
    selectedTab = 0;
    notifyListeners();
  }

  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  void toggleBookmark(String titleId) {
    if (bookmarks.contains(titleId)) {
      bookmarks.remove(titleId);
    } else {
      bookmarks.add(titleId);
    }
    notifyListeners();
  }

  bool isBookmarked(String titleId) => bookmarks.contains(titleId);

  void addToCart(String itemName) {
    cart.add(itemName);
    notifyListeners();
  }

  String get savedLabel {
    final count = bookmarks.length;
    return '$count ${count == 1 ? 'title' : 'titles'} saved';
  }

  String titleNameFor(String id) {
    for (final title in demoTitles) {
      if (title.id == id) return title.name;
    }
    return 'Fandom title';
  }
}
