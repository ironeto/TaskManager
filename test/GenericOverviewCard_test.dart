import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_pk/GenericOverviewCard.dart';
import 'package:shared_pk/IGenericOverviewCard.dart';

class MockProvider extends Mock implements IGenericOverviewCard {}

void main() {
  group('GenericOverviewCard', () {
    testWidgets('should display label and count from the provider', (WidgetTester tester) async {
      final mockProvider = MockProvider();
      when(() => mockProvider.countItems()).thenReturn(5);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider<IGenericOverviewCard>.value(
              value: mockProvider,
              child: GenericOverviewCard<IGenericOverviewCard>(
                labelForCounter: 'Tasks',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });
  });
}
