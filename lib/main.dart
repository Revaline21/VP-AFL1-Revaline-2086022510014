import 'package:flutter/material.dart';
import 'Features/Screen/vault_screen.dart';
import 'Features/Screen/Widget/vault_item.dart';

void main() => runApp(const VaultApp());

class VaultApp extends StatelessWidget {
  final List <VaultItem>? initialItems;
    final ThemeMode themeMode;
    const VaultApp({super.key, this.initialItems, this.themeMode = ThemeMode.system});

  static const Color _seed = Color(0xFF00695C);

  ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: brightness,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collector Vault',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: themeMode,
      home:VaultScreen(initialItems: initialItems),
    );
  }
}