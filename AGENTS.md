# AGENTS.md - fading_marquee_widget

## Project Overview
A lightweight Flutter package providing marquee (auto-scrolling) effects for long widgets with fading edges. Version 1.2.0, Dart SDK ^3.8.0.

## Architecture

### Core Components
- **`FadingMarqueeWidget`** (lib/src/fading_marquee_widget.dart) - Main public widget
  - StatefulWidget wrapping animation logic and scroll control
  - Handles both horizontal and vertical marquee effects
  - RTL-aware through `Directionality.of(context)` checks
  
- **`FadingEdgeScrollView`** (lib/src/fading_edge_scroll_view.dart) - Internal rendering layer
  - Applies gradient fade masks to scroll view edges
  - Uses `ShaderMask` with `LinearGradient` for visual fading
  - Smart gradient calculation based on scroll position (5 factory constructors support ScrollView, SingleChildScrollView, PageView, AnimatedList, ListWheelScrollView)

- **Public API** (lib/fading_marquee_widget.dart)
  - Single export file pattern - only exposes `FadingMarqueeWidget`

### Animation Flow
1. `initState()` → triggers `animationHandler()` via `WidgetsBinding.addPostFrameCallback()`
2. *Delay* → waits `widget.delay` before starting
3. *Tiny offset hack* → `scrollController.jumpTo(0.000000000000000001)` triggers SlideTransition
4. *Animation loop* → `AnimationController.forward()` with `SlideTransition` position offset
5. *Pause* → waits `widget.pause`, then loops back to step 2

### RTL Support Pattern
```dart
// Animation offset adapts to text direction
final isRTL = Directionality.of(context) == TextDirection.rtl;
offset = Tween<Offset>(
  begin: Offset.zero,
  end: isRTL ? const Offset(.5, 0) : const Offset(-.5, 0),  // +0.5 for RTL (move right), -0.5 for LTR (move left)
).animate(animationController);
```
Wrap widget with `Directionality(textDirection: TextDirection.rtl, child: FadingMarqueeWidget(...))`

## Key Implementation Patterns

### State Management
- Uses `ValueNotifier<bool> shouldScroll` for reactive child widget duplication
- Widget only duplicates when content overflows (scrollable)
- Doubles child in Row/Column layout only if `shouldScroll.value == true`
- See `buildHorizontalWidget()` and `buildVerticalWidget()` methods

### Lifecycle Safety
- All async operations check `mounted` before state changes
- `ScrollController.hasClients` validated before accessing position
- Retry logic: `if (!scrollController.hasClients) { await Future.delayed(...); }`
- Proper disposal of AnimationController and ScrollController in `dispose()`

### Animation Controller Setup
```dart
animationController = AnimationController(
  duration: widget.duration,  // 10 seconds default
  vsync: this,  // SingleTickerProviderStateMixin
);
```

### Widget ID Parameter
```dart
final String? id;  // Pass static ID to prevent rebuild when parent rebuilds
// Default: `DateTime.now().toString()` if not provided
// Use case: Preserve animation state across parent rebuilds
```

### Gradient Edge Fading
Controlled by `gradientFractionOnStart` and `gradientFractionOnEnd` (0-1 range):
- 0 = no gradient (full color)
- 1 = full gradient coverage
- Defaults: 0.1 when animation enabled, 0 when disabled
- **Configurable**: Pass custom values to `FadingMarqueeWidget()` constructor to customize fade width

### Fade Duration
Controlled by `fadeDuration` parameter (default: 300ms):
- Controls the transition duration when fades appear/disappear
- Applied when scroll state changes (scrollable → not scrollable, etc.)
- Animated via `AnimationController` with `Curves.easeInOut`
- **Usage**: `FadingMarqueeWidget(fadeDuration: Duration(milliseconds: 500), ...)`

## Testing Strategy

### Test Location
`test/fading_marquee_widget_test.dart` - Widget tests using `flutter_test`

### Test Coverage Patterns
- LTR text (English)
- RTL text (Arabic: "اختبار النجاح")
- Custom widgets (Row with Icon + Text)
- Vertical scroll direction with RTL
- All wrapped with `Directionality` widget

### Run Tests
```bash
flutter test
```

## Configuration & Dependencies

### pubspec.yaml Essentials
- **flutter_lints**: ^6.0.0 (strict linting, no custom rules)
- **Minimum Dart**: 3.8.0
- **No third-party dependencies** - pure Flutter APIs only

### Code Style
- Uses `analysis_options.yaml` with `package:flutter_lints/flutter.yaml`
- Dart formatter applied (see CHANGELOG v1.0.3+1)

## Common Development Tasks

### Customizing Fade Width and Duration
```dart
FadingMarqueeWidget(
  child: Text("Your long text..."),
  gradientFractionOnStart: 0.15,    // Wider fade at start (0-1)
  gradientFractionOnEnd: 0.2,       // Wider fade at end (0-1)
  fadeDuration: Duration(milliseconds: 500),  // Fade transition time
)
```
- Fade widths are independent per edge
- `fadeDuration` only applies when scroll state changes
- Works with `disableAnimation: true` (fades won't show, but duration is still configurable)

### Advanced: Using FadingEdgeScrollView Directly
All factory constructors support gradient and fade parameters:
```dart
FadingEdgeScrollView.fromScrollView(
  child: myScrollView,
  gradientFractionOnStart: 0.3,
  gradientFractionOnEnd: 0.3,
  fadeDuration: Duration(milliseconds: 600),
)
```
Supported factories: `fromScrollView`, `fromSingleChildScrollView`, `fromPageView`, `fromAnimatedList`, `fromListWheelScrollView`
1. Update animation offset in `_updateAnimationOffset()` - vertical uses `Offset(0, -.5)`
2. Update child layout in `build()` - return `buildVerticalWidget()` vs `buildHorizontalWidget()`
3. Add test in `test/fading_marquee_widget_test.dart`

### Debugging Animation Issues
- Check if ScrollController has clients: `scrollController.hasClients`
- Verify maxScrollExtent: `scrollController.position.maxScrollExtent > 0`
- Enable animation: `disableAnimation = false`
- RTL offset should be positive: `Offset(.5, 0)` not negative

### Testing RTL
Always wrap with:
```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: FadingMarqueeWidget(...)
)
```

## File Organization
```
lib/
├── fading_marquee_widget.dart       # Public API (export only)
└── src/
    ├── fading_marquee_widget.dart   # Main implementation
    └── fading_edge_scroll_view.dart # Gradient fade layer
example/lib/main.dart               # Full demo of all features
test/                               # Widget tests
```

## Release Process Insights
- Version 1.2.0 added RTL support (recent feature)
- Version 1.1.0 removed third-party deps (prefer native Flutter)
- Minimum versions: Dart 3.8.0, flutter_lints 6.0.0
- See CHANGELOG.md for deprecation history

## Critical Gotchas
1. **Mounted checks required** - Animation runs post-frame; actor may be disposed
2. **ScrollController attachment** - Must wait for `hasClients` before accessing position
3. **Tiny offset hack** - `jumpTo(0.000000000000000001)` triggers visual effect; necessary quirk
4. **Gradient math** - `gradientFractionOnStart * 0.5` in stops array (asymmetric fade)
5. **RTL sign inversion** - Positive offset for RTL (+0.5), negative for LTR (-0.5)
6. **Fade animation state** - `FadingEdgeScrollViewState` uses `SingleTickerProviderStateMixin` for fade controller; doesn't conflict with marquee animation controller (separate instances)

