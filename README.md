# TeamFlow

A Flutter mobile productivity app to browse team tasks, projects, and people.

---

## Getting Started
```bash
flutter pub get
flutter run
```

---

## Architecture

Clean Architecture with three layers:

- **Presentation** — screens, widgets, Riverpod notifiers
- **Domain** — pure Dart entities, use cases, repository interfaces
- **Data** — DTOs, Dio API calls, repository implementations

The UI never touches the API directly. Each layer only talks to the one below it.

---

## Dependency Injection

Riverpod providers act as the DI container. All wiring is in `lib/di/providers.dart`. Repository providers are typed as abstract interfaces so implementations can be swapped without touching the UI.

---

## State Management

Riverpod 2.x with `AsyncNotifier`. Every screen handles loading, error, and data states via `AsyncValue.when()`. Pull-to-refresh calls `refresh()` on the notifier.

---

## Error Handling

A Dio interceptor maps all HTTP errors to typed `AppException` subclasses before they reach the UI. The screen only reads `exception.message` — never a raw HTTP error.

---

## Running Tests
```bash
flutter test
```

---

## Known Limitations

- No offline support — requires live API connection
- App is read-only — no task creation or editing
- Avatar images fall back to initials (API returns SVG URLs)

---

## Bonus Features

- Project detail screen
- User detail screen
- Custom pill-shaped bottom navigation bar
- Background image on all screens
- Overdue date detection

## Error Handling

A Dio interceptor maps all HTTP errors to typed `AppException` subclasses before they reach the UI. The screen only reads `exception.message` — never a raw HTTP error.

---

## Running Tests
```bash
flutter test
```

---

## Known Limitations

- No offline support — requires live API connection
- App is read-only — no task creation or editing
- Avatar images fall back to initials (API returns SVG URLs)

---

## Bonus Features

- Project detail screen
- User detail screen
- Custom pill-shaped bottom navigation bar
- Background image on all screens
- Overdue date detection