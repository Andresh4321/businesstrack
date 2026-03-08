/// Comprehensive Widget Tests - Part 2
/// Tests for Production, Stock, Dashboard, and Settings widgets
///
/// Widget Test Coverage Table:
/// ┌────┬─────────────────────────────┬────────────────────────────┬────────┐
/// │ ID │ Widget/Page                 │ Test Scenario              │ Status │
/// ├────┼─────────────────────────────┼────────────────────────────┼────────┤
/// │ 11 │ ProductionPage              │ Renders production UI      │   ✓    │
/// │ 12 │ ProductionPage              │ Has action buttons         │   ✓    │
/// │ 13 │ StockManagementPage         │ Displays stock interface   │   ✓    │
/// │ 14 │ StockManagementPage         │ Has transaction list       │   ✓    │
/// │ 15 │ DashboardScreen             │ Shows dashboard widgets    │   ✓    │
/// │ 16 │ DashboardScreen             │ Has navigation elements    │   ✓    │
/// │ 17 │ SettingScreen               │ Settings list rendered     │   ✓    │
/// │ 18 │ SettingScreen               │ Has Premium section        │   ✓    │
/// │ 19 │ PremiumPlansPage            │ Shows plan cards           │   ✓    │
/// │ 20 │ PremiumPlansPage            │ Has purchase buttons       │   ✓    │
/// └────┴─────────────────────────────┴────────────────────────────┴────────┘

import 'package:businesstrack/features/dashboard/presentation/pages/dashboard_screen_improved.dart';
import 'package:businesstrack/features/production/presentation/pages/production_page.dart';
import 'package:businesstrack/features/stock/presentation/pages/stock_management_page.dart';
import 'package:businesstrack/features/users/presentation/pages/premium_plans_page.dart';
import 'package:businesstrack/features/users/presentation/pages/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Helper function to wrap widgets with mocked providers
  Widget makeTestableWidget(Widget child) {
    return ProviderScope(child: MaterialApp(home: child));
  }

  group('ProductionPage Widget Tests', () {
    testWidgets('Test 11 - ProductionPage renders basic structure', (
      tester,
    ) async {
      // Arrange
      final widget = makeTestableWidget(const ProductionPage());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Test 12 - ProductionPage has action button', (tester) async {
      // Arrange
      final widget = makeTestableWidget(const ProductionPage());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('StockManagementPage Widget Tests', () {
    testWidgets('Test 13 - StockManagementPage renders structure', (
      tester,
    ) async {
      // Arrange
      final widget = makeTestableWidget(const StockManagementPage());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Test 14 - StockManagementPage has action button', (
      tester,
    ) async {
      // Arrange
      final widget = makeTestableWidget(const StockManagementPage());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });

  group('DashboardScreen Widget Tests', () {
    testWidgets('Test 15 - DashboardScreen renders structure', (tester) async {
      // Arrange
      final widget = makeTestableWidget(const DashboardScreen());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Test 16 - DashboardScreen has app bar', (tester) async {
      // Arrange
      final widget = makeTestableWidget(const DashboardScreen());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('SettingScreen Widget Tests', () {
    testWidgets('Test 17 - SettingScreen renders structure', (tester) async {
      // Arrange
      final widget = makeTestableWidget(const SettingScreen());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Test 18 - SettingScreen has Premium section', (tester) async {
      // Arrange
      final widget = makeTestableWidget(const SettingScreen());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert - Look for premium related elements
      expect(find.text('Premium'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium), findsOneWidget);
    });
  });

  group('PremiumPlansPage Widget Tests', () {
    testWidgets('Test 19 - PremiumPlansPage shows plan cards', (tester) async {
      // Arrange
      final widget = makeTestableWidget(const PremiumPlansPage());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Premium Plans'), findsOneWidget);
      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('Extended'), findsOneWidget);
      expect(find.text('Pro'), findsOneWidget);
    });

    testWidgets('Test 20 - PremiumPlansPage has purchase buttons', (
      tester,
    ) async {
      // Arrange
      final widget = makeTestableWidget(const PremiumPlansPage());

      // Act
      await tester.pumpWidget(widget);
      await tester.pump();

      // Assert - Check for button widgets
      expect(
        find.widgetWithText(ElevatedButton, 'Choose Basic'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(ElevatedButton, 'Choose Extended'),
        findsOneWidget,
      );
      expect(find.widgetWithText(ElevatedButton, 'Choose Pro'), findsOneWidget);
    });
  });
}
