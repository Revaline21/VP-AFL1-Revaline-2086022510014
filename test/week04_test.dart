import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week04/main.dart' show VaultApp;
import 'package:week04/Features/Screen/Widget/vault_item.dart';
import 'package:week04/Features/Screen/Widget/vault_item_tile.dart';

const Size small = Size(320, 568);
const Size large = Size(430, 932);
const Size tablet = Size(800, 1280);

const List<(String, Size)> screens = [
  ('small phone', small),
  ('large phone', large),
  ('tablet', tablet),
];

VaultItem _item(int i, String name) {
  return VaultItem(
    id: 'v$i',
    name: name,
    category: 'Electronics',
    condition: Condition.values[i % Condition.values.length],
    value: 50000.0 + (i % 20) * 10000,
    purchaseDate: DateTime(2025, 1, 1).add(Duration(days: i)),
  );
}

List<VaultItem> sampleItems(int count) =>
    List.generate(count, (i) => _item(i, 'Item ${i + 1}'));

final String longName = List.filled(20, 'abcdefghi ').join();

Future<void> pumpScreen(
  WidgetTester tester,
  Size size, {
  List<VaultItem>? items,
  double keyboard = 0,
  double topInset = 0,
  double bottomInset = 0,
  ThemeMode mode = ThemeMode.light,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  tester.view.padding = FakeViewPadding(top: topInset, bottom: bottomInset);
  tester.view.viewPadding = FakeViewPadding(top: topInset, bottom: bottomInset);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    VaultApp(initialItems: items ?? sampleItems(3), themeMode: mode),
  );
  await tester.pumpAndSettle();
}

void expectNoLayoutErrors(WidgetTester tester) {
  final Object? error = tester.takeException();
  expect(error, isNull, reason: 'Layout error:\n$error');
}

Finder get mainScrollable => find
    .byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
    )
    .first;

void main() {
  group('Week 04 - Collector Vault', () {
    for (final (name, size) in screens) {
      testWidgets('1-3 · portrait - $name', (tester) async {
        await pumpScreen(tester, size);
        expectNoLayoutErrors(tester);
      });
    }

    for (final (name, size) in screens) {
      testWidgets('4 · landscape - $name', (tester) async {
        await pumpScreen(tester, size.flipped);
        expectNoLayoutErrors(tester);
      });
    }

    for (final (name, size) in screens) {
      testWidgets('5 · nama 200 karakter - $name', (tester) async {
        await pumpScreen(
          tester,
          size,
          items: [_item(0, longName), ...sampleItems(3)],
        );
        expectNoLayoutErrors(tester);
      });
    }

    testWidgets('6 · zero items menampilkan empty state', (tester) async {
      await pumpScreen(tester, small, items: const <VaultItem>[]);
      expectNoLayoutErrors(tester);
      expect(find.byKey(const Key('empty-state')), findsOneWidget,
          reason: "Butuh widget dengan key: const Key('empty-state').");
    });

    testWidgets('7 · 500 items dibangun lazy', (tester) async {
      await pumpScreen(tester, small, items: sampleItems(500));
      expectNoLayoutErrors(tester);
      expect(find.byType(VaultItemTile).evaluate().length, lessThan(100),
          reason: 'Hanya item yang terlihat yang boleh dibangun.');

      for (var i = 0; i < 5; i++) {
        await tester.fling(mainScrollable, const Offset(0, -2000), 3000);
        await tester.pumpAndSettle();
      }
      expectNoLayoutErrors(tester);
    });

    testWidgets('8 · keyboard terbuka tidak membuat overflow', (tester) async {
      await pumpScreen(tester, small, keyboard: 260);
      expectNoLayoutErrors(tester);
    });

    testWidgets('8 · keyboard terbuka di landscape', (tester) async {
      await pumpScreen(tester, small.flipped, keyboard: 180);
      expectNoLayoutErrors(tester);
    });

    for (final (name, size) in screens) {
      testWidgets('9 · dark mode - $name', (tester) async {
        await pumpScreen(tester, size, mode: ThemeMode.dark);
        expectNoLayoutErrors(tester);
      });
    }

    testWidgets('Bonus · notch dan gesture bar', (tester) async {
      await pumpScreen(tester, small, topInset: 32, bottomInset: 20);
      expectNoLayoutErrors(tester);
    });
  });
}