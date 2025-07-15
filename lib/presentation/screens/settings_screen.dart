import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/presentation/bloc/theme_cubit.dart';
import 'package:pdf_reader/presentation/bloc/wakelock_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, currentMode) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text("Theme Mode", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),

              _buildThemeTile(
                context,
                title: 'Light',
                icon: Icons.light_mode,
                previewColor: Colors.white,
                value: ThemeMode.light,
                groupValue: currentMode,
              ),

              _buildThemeTile(
                context,
                title: 'Dark',
                icon: Icons.dark_mode,
                previewColor: const Color(0xFF121212),
                value: ThemeMode.dark,
                groupValue: currentMode,
              ),

              _buildThemeTile(
                context,
                title: 'System Default',
                icon: Icons.settings,
                previewColor: Theme.of(context).colorScheme.surface,
                value: ThemeMode.system,
                groupValue: currentMode,
              ),
              BlocBuilder<WakelockCubit, bool>(
                builder: (context, keepAwake) {
                  return SwitchListTile(
                    title: const Text("Keep Screen Awake"),
                    subtitle: const Text(
                      "Prevent screen from sleeping while reading",
                    ),
                    value: keepAwake,
                    onChanged: (val) {
                      context.read<WakelockCubit>().toggle();
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color previewColor,
    required ThemeMode value,
    required ThemeMode groupValue,
  }) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => context.read<ThemeCubit>().setTheme(value),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor,
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            Container(
              width: 40,
              height: 28,
              decoration: BoxDecoration(
                color: previewColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(width: 8),
            Radio<ThemeMode>(
              value: value,
              groupValue: groupValue,
              onChanged: (_) => context.read<ThemeCubit>().setTheme(value),
            ),
          ],
        ),
      ),
    );
  }
}
