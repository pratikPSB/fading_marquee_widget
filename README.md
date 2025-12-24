# fading_marquee_widget

This package I have made for apply the marquee (scrolling effect in one line) effect for the very long widget.

### Installation Guide

1. Install or update fading_marquee_widget:
   ```shell 
   flutter pub add fading_marquee_widget
   ```
2. Or else in your `pubspec.yaml` file, add below code (and run an implicit `flutter pub get`
   command in terminal):
   ```yaml
   dependencies:
   fading_marquee_widget: ^1.0.0
   ```

### Usage in code

#### necessary import

```dart
import 'package:fading_marquee_widget/fading_marquee_widget.dart';
```

#### simple usage

```dart
FadingMarqueeWidget(
   child: Text(
      "very very very very very very very very very very long text.",
      style: TextStyle(color: Colors.white),
   ),
)
```

#### full use of the package's customizability

```dart
FadingMarqueeWidget(
   duration: Duration(seconds: 5),
   scrollDirection: Axis.horizontal,
   gap: 100,
   pause: Duration(milliseconds: 50),
   delay: Duration(milliseconds: 50),
   disableAnimation: false,
   id: "any static id in string to avoid false build",
   child: Text(
      "Duration of the animation is 5 seconds. The default duration is 10 seconds. very very very very very very very very very very long text.",
      style: TextStyle(color: Colors.white),
   ),
)
```

#### RTL (Right-to-Left) Support

The widget automatically adapts to RTL text direction. Simply wrap it with `Directionality` widget:

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: FadingMarqueeWidget(
    child: Text(
      "نص طويل جداً جداً جداً جداً جداً جداً جداً جداً جداً جداً",
      style: TextStyle(color: Colors.white),
    ),
  ),
)
```

The widget also works with custom widgets containing RTL text:

```dart
Directionality(
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
)
```
_Appreciate my work? Show some ❤️ and star the repo to support this package._

### Here is the working video of this package

<img src="https://github.com/pratikPSB/fading_marquee_widget/blob/master/fading_marquee_widget_demo.gif?raw=true" height="400"  alt="working demo of my package"/>

For more information about the properties, look at the [API reference](https://pub.dev/documentation/fading_marquee_widget/latest/).