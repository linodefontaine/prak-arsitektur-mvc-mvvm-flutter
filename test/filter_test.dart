import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prak_arsitektur_tugas/main.dart';

void main() {
  for (final mode in ['MVC', 'MVVM']) {
    testWidgets('$mode menyaring tugas belum selesai dengan benar', (tester) async {
      await tester.pumpWidget(const AplikasiTugas());
      await tester.tap(find.text('Buka $mode'));
      await tester.pumpAndSettle();

      final input = find.byKey(const ValueKey('judul-tugas'));
      final tambah = find.text('Tambah tugas');
      final chipFilter = find.byKey(const ValueKey('filter-belum-selesai'));

      await tester.enterText(input, 'Rancang UI Flutter');
      await tester.tap(tambah);
      await tester.pumpAndSettle();

      await tester.enterText(input, 'Catat hasil pengujian');
      await tester.tap(tambah);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();

      expect(find.text('Rancang UI Flutter'), findsOneWidget);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      expect(find.text('1 dari 2 selesai'), findsOneWidget);

      await tester.tap(chipFilter);
      await tester.pumpAndSettle();

      expect(find.text('Rancang UI Flutter'), findsNothing);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      expect(find.text('1 dari 2 selesai'), findsOneWidget);

      await tester.tap(chipFilter);
      await tester.pumpAndSettle();

      expect(find.text('Rancang UI Flutter'), findsOneWidget);
      expect(find.text('Catat hasil pengujian'), findsOneWidget);
      final checkboxPertama = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile).first,
      );
      expect(checkboxPertama.value, isTrue);

      await tester.tap(chipFilter);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pumpAndSettle();

      expect(find.text('Tidak ada tugas yang belum selesai.'), findsOneWidget);
      expect(find.text('2 dari 2 selesai'), findsOneWidget);
    });
  }
}