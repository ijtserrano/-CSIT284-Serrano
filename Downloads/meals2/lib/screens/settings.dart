import 'package:flutter/material.dart';
import 'package:meals2/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Appearance', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, mode, _) => SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text('Light'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text('Dark'),
                ),
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.settings_suggest),
                  label: Text('System'),
                ),
              ],
              selected: {mode},
              onSelectionChanged: (selection) =>
                  themeModeNotifier.value = selection.first,
            ),
          ),
          const SizedBox(height: 32),
          Text('About', style: theme.textTheme.titleLarge),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('About Meals'),
            subtitle: const Text('Version 1.0.0'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'Meals',
              applicationVersion: '1.0.0',
              applicationIcon: const Icon(Icons.fastfood, size: 40),
              children: const [
                Text('Browse meal categories, filter by diet, '
                    'search recipes and save your favorites.'),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.description_outlined),
            title: const Text('Open source licenses'),
            onTap: () => showLicensePage(context: context),
          ),
        ],
      ),
    );
  }
}