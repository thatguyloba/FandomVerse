# Fandom Verse Pocket Edition

A polished Flutter mobile app concept for **Fandom Verse** — a single home for anime, gaming, comics and pop-culture discovery.

This build follows the supplied visual direction without copying the healthcare or football content: deep ink surfaces, soft elevated cards, vibrant lavender/coral accents, rounded mobile-first layouts and small motion moments across the experience.

## Included screens

- Animated branded splash screen with custom **Fandom Verse portal mark**
- Login and create-account flows with interest selection
- Home dashboard with featured universe carousel, fandom pulse, events and Verse Market entry
- Discover screen with search, category filters, editorial cards and title grid
- Title detail screen with score, lore drops, related titles and save/bookmark animation
- Personal library with saved titles
- Verse Guide AI fan-helper conversation UI with typing state and suggested prompts
- Event discovery list and event detail screen
- Verse Market storefront with animated cart count and checkout sheet
- Profile, interests and preference toggles
- Creator studio / admin moderation dashboard
- Smooth page routes, implicit animations, animated switchers, animated bookmark buttons, carousel dots and loading states

## Run it

1. Install Flutter 3.22+ and verify the toolchain:

   ```bash
   flutter doctor
   ```

2. From this directory, generate the native platform folders once (the source and design system are already here):

   ```bash
   flutter create .
   flutter pub get
   flutter run
   ```

3. The demo auth is intentionally local so the UI can be reviewed immediately. Any email containing `@` and a password of six or more characters will enter the demo app.

## Backend hand-off points

`lib/services/app_controller.dart` owns the local demo state. Replace or wrap these methods with Firebase services when connecting the real product:

- `signIn` / `signOut` → Firebase Authentication
- `bookmarks` → Firestore user collection
- `cart` → Firestore cart or a checkout service
- `demo_data.dart` → Firestore content, event, merch and news collections
- Verse Guide response in `assistant_screen.dart` → Gemini / LLM API through a protected server function

Do not call an LLM API key directly from the shipped client. Put the AI request behind a Firebase Cloud Function or another authenticated server endpoint.

## Design notes

The logo is drawn with Flutter `CustomPainter`, not a random external image: a four-point signal star sits inside an orbital ring, representing a fan finding a new universe and the connected community around it. All artwork in this prototype is generated from gradients, icons and the same mark, so the app has no missing asset or font dependency. Replace `FandomArtwork` with licensed cover art later while keeping the same card API.
