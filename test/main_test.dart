import 'package:f5_danhsach/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats prices with Vietnamese thousands separators', () {
    expect(dinhDangGia(180000), '180.000 đ');
    expect(dinhDangGia(0), '0 đ');
    expect(dinhDangGia(-1200), '-1.200 đ');
  });

  testWidgets('shows all six sample products and formatted prices', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Danh sách sản phẩm'), findsOneWidget);
    expect(find.text('Áo thun VHU'), findsOneWidget);
    expect(find.text('Bình giữ nhiệt'), findsOneWidget);
    expect(find.text('Sổ tay sinh viên'), findsOneWidget);
    expect(find.text('180.000 đ'), findsOneWidget);
    expect(_productCount(tester), 6);

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('Cốc sứ in hình'), findsOneWidget);
  });

  testWidgets('adds a product to the top of the list', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byTooltip('Thêm sản phẩm'));
    await tester.pumpAndSettle();

    expect(find.text('Sản phẩm mới 7'), findsOneWidget);
    expect(_productCount(tester), 7);
    expect(
      tester.getTopLeft(find.text('Sản phẩm mới 7')).dy,
      lessThan(tester.getTopLeft(find.text('Áo thun VHU')).dy),
    );
  });

  testWidgets('removes the swiped middle item without removing its neighbor', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.drag(find.byKey(const ValueKey<int>(3)), const Offset(-600, 0));
    await tester.pumpAndSettle();

    expect(find.text('Sổ tay sinh viên'), findsNothing);
    expect(find.text('Bình giữ nhiệt'), findsOneWidget);
    expect(find.text('Balo laptop'), findsOneWidget);
    expect(_productCount(tester), 5);
  });

  testWidgets('search filters by name and can be cleared', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byKey(const ValueKey('product-search')), 'balo');
    await tester.pumpAndSettle();

    expect(find.text('Balo laptop'), findsOneWidget);
    expect(find.text('Áo thun VHU'), findsNothing);

    await tester.tap(find.byTooltip('Xóa tìm kiếm'));
    await tester.pumpAndSettle();
    expect(_productCount(tester), 6);
  });

  testWidgets('shows an empty state after deleting every product', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    for (var id = 1; id <= 6; id++) {
      await tester.drag(find.byKey(ValueKey<int>(id)), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey<int>(id)), findsNothing);
    }

    expect(find.text('Danh sách trống'), findsOneWidget);
    expect(find.text('Thêm sản phẩm'), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('keeps a two-column product grid in landscape', (tester) async {
    tester.view.physicalSize = const Size(1200, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Lưới'));
    await tester.pumpAndSettle();

    expect(find.text('Album ảnh'), findsOneWidget);
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2);
    expect(grid.childrenDelegate.estimatedChildCount, 6);
  });
}

int? _productCount(WidgetTester tester) {
  final list = tester.widget<ListView>(find.byType(ListView));
  return list.childrenDelegate.estimatedChildCount;
}
