# Flutter Expense Tracker - Lesson 5

## Run
```
flutter create .        # once: generates web/android/ios folders
flutter pub get
flutter run -d chrome
```

## Reference
Structured after the course snapshot `05 Interactivity & Theming / 24 Finished`
(`widgets/expenses_list/`, `widgets/chart/`, `ExpenseBucket.forCategory`, uuid ids,
DropdownButton category, `showDatePicker` Future, validation dialog, Dismissible + SnackBar undo).

## Lesson 5 concepts
- **Interactions:** FAB + bottom sheet, TextFields, date picker, ChoiceChips, FilledButton/TextButton, validation dialog, swipe-to-delete with Undo snackbar.
- **App-wide theme:** `lib/theme/app_theme.dart` (light + dark, toggle in the app bar).
- **Colors/typography:** own "Lagoon Sunset" palette (teal + coral), Poppins font (400/500/600).
- **Reusable styling:** component themes for AppBar, Card, buttons, inputs, sheets, snackbars, dialogs.

## My customizations
- Custom palette + custom font + dark mode
- Responsive layout (chart beside list on wide screens)
- Animations: animated chart bars & total counter, card slide/fade-in, rotating theme icon, empty-state cross-fade
- Redesigned cards (category avatar, colored amounts), gradient chart panel
- Extras: total spent counter, undo delete, empty state, chart tooltips
