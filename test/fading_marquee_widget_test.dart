import 'package:fading_marquee_widget/fading_marquee_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "marquee widget LTR test",
    (widgetTester) async {
      var widget = const Directionality(
          textDirection: TextDirection.ltr,
          child: FadingMarqueeWidget(child: Text("testing success")));
      await widgetTester.pumpWidget(widget);
      final foundText = find.byWidget(widget);
      expect(foundText, findsOneWidget);
    },
  );

  testWidgets(
    "marquee widget RTL test",
    (widgetTester) async {
      var widget = const Directionality(
          textDirection: TextDirection.rtl,
          child: FadingMarqueeWidget(child: Text("اختبار النجاح")));
      await widgetTester.pumpWidget(widget);
      final foundText = find.byWidget(widget);
      expect(foundText, findsOneWidget);
    },
  );

  testWidgets(
    "marquee widget with custom widget child",
    (widgetTester) async {
      var widget = const Directionality(
        textDirection: TextDirection.rtl,
        child: FadingMarqueeWidget(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star),
              SizedBox(width: 8),
              Text("نص مع أيقونة"),
            ],
          ),
        ),
      );
      await widgetTester.pumpWidget(widget);
      final foundWidget = find.byWidget(widget);
      expect(foundWidget, findsOneWidget);
    },
  );

  testWidgets(
    "marquee widget vertical direction with RTL",
    (widgetTester) async {
      var widget = const Directionality(
        textDirection: TextDirection.rtl,
        child: FadingMarqueeWidget(
          scrollDirection: Axis.vertical,
          child: Text("نص عمودي طويل جداً"),
        ),
      );
      await widgetTester.pumpWidget(widget);
      final foundWidget = find.byWidget(widget);
      expect(foundWidget, findsOneWidget);
    },
  );
}
