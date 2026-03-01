import 'package:businesstrack/core/sensors/light_sensor_provider.dart';
import 'package:businesstrack/core/sensors/light_sensor_state.dart';
import 'package:businesstrack/core/sensors/widgets/light_sensor_indicator.dart';
import 'package:businesstrack/features/auth/presentation/widgets/text_layout.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/module_button.dart';
import 'package:businesstrack/features/dashboard/presentation/widgets/overview_tab.dart';
import 'package:businesstrack/features/users/presentation/widgets/settingTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widgets', () {
    testWidgets('1) TextLayout renders label, hint and icon', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: TextLayout(
                controller: controller,
                label: 'Email',
                hint: 'Enter email',
                icon: Icons.email,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter email'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('2) TextLayout validator shows error for empty value', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextLayout(
                controller: controller,
                label: 'Password',
                hint: 'Enter password',
                icon: Icons.lock,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Please enter Password'), findsOneWidget);
    });

    testWidgets('3) TextLayout validator passes when text is provided', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController(text: 'value');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextLayout(
                controller: controller,
                label: 'Field',
                hint: 'hint',
                icon: Icons.abc,
              ),
            ),
          ),
        ),
      );

      final valid = formKey.currentState!.validate();
      expect(valid, isTrue);
      expect(find.textContaining('Please enter'), findsNothing);
    });

    testWidgets('4) TextLayout sets obscureText when requested', (
      tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextLayout(
              controller: controller,
              label: 'Secret',
              hint: 'hint',
              icon: Icons.key,
              obscureText: true,
            ),
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.obscureText, isTrue);
    });

    testWidgets('5) TextLayout applies keyboardType', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextLayout(
              controller: controller,
              label: 'Phone',
              hint: 'hint',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.keyboardType, TextInputType.phone);
    });

    testWidgets('6) Settingtile renders title and icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Settingtile(icon: Icons.settings, title: 'Settings'),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('7) Settingtile shows default trailing icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Settingtile(icon: Icons.settings, title: 'Settings'),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
    });

    testWidgets('8) Settingtile accepts custom trailing widget', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Settingtile(
              icon: Icons.settings,
              title: 'Settings',
              trailing: Icon(Icons.done),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.done), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsNothing);
    });

    testWidgets('9) Settingtile calls onTap callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Settingtile(
              icon: Icons.settings,
              title: 'Settings',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('10) DashboardStatCard renders text values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardStatCard(
              title: 'Revenue',
              value: '1200',
              subtitle: 'Today',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('1200'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('11) DashboardStatCard renders icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardStatCard(
              title: 'Revenue',
              value: '1200',
              subtitle: 'Today',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.attach_money), findsOneWidget);
    });

    testWidgets('12) DashboardStatCard contains Card widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardStatCard(
              title: 'Orders',
              value: '5',
              subtitle: 'Open',
              icon: Icons.shopping_cart,
              color: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('13) DashboardStatCard applies icon color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DashboardStatCard(
              title: 'Orders',
              value: '5',
              subtitle: 'Open',
              icon: Icons.shopping_cart,
              color: Colors.blue,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.shopping_cart));
      expect(icon.color, Colors.blue);
    });

    testWidgets('14) ModuleButton renders title and description', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModuleButton(
              title: 'Production',
              description: 'Manage batches',
              icon: Icons.factory,
              color: Colors.orange,
              onPress: () {},
            ),
          ),
        ),
      );

      expect(find.text('Production'), findsOneWidget);
      expect(find.text('Manage batches'), findsOneWidget);
    });

    testWidgets('15) ModuleButton renders icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModuleButton(
              title: 'Production',
              description: 'Manage batches',
              icon: Icons.factory,
              color: Colors.orange,
              onPress: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.factory), findsOneWidget);
    });

    testWidgets('16) ModuleButton calls onPress when tapped', (tester) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModuleButton(
              title: 'Production',
              description: 'Manage batches',
              icon: Icons.factory,
              color: Colors.orange,
              onPress: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('17) ModuleButton contains Card widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModuleButton(
              title: 'Production',
              description: 'Manage batches',
              icon: Icons.factory,
              color: Colors.orange,
              onPress: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('18) OverviewTab renders title, value and icon', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OverviewTab(
              title: 'Sales',
              value: '500',
              icon: Icons.show_chart,
            ),
          ),
        ),
      );

      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
      expect(find.byIcon(Icons.show_chart), findsOneWidget);
    });

    testWidgets('19) OverviewTab applies iconColor when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OverviewTab(
              title: 'Sales',
              value: '500',
              icon: Icons.show_chart,
              iconColor: Colors.purple,
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.show_chart));
      expect(icon.color, Colors.purple);
    });

    testWidgets('20) LightSensorIndicator shows compact data from provider', (
      tester,
    ) async {
      final state = LightSensorState(
        lightLevel: 150,
        isDarkMode: true,
        lightCondition: 'Dark',
        isActive: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lightSensorStateProvider.overrideWith((ref) => Stream.value(state)),
          ],
          child: const MaterialApp(
            home: Scaffold(body: LightSensorIndicator(compact: true)),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('150'), findsOneWidget);
      expect(find.byIcon(Icons.nightlight_round), findsOneWidget);
    });
  });
}
