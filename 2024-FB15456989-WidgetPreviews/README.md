# FB15456989: SwiftUI #Preview macro with timelineProvider: only works with static not configurable widgets

Here is an example:

```
#Preview(as: .systemSmall) {
    StaticWidget()
} timelineProvider: {
    var provider = StaticProvider()
    // This works as expected, the preview shows "Orange" instead of the default "Red".
    provider.name = "Orange"
    return provider
}

#Preview(as: .systemSmall, using: MyWidgetConfiguration()) {
    ConfigurableWidget()
} timelineProvider: {
    var provider = IntentProvider()
    // BUG: This has no effect.
    provider.name = "Orange"
    return provider
}
```

Both of the `#Preview`s are using the version that uses a `timelineProvider:` parameter. The difference is that one is a `StaticConfiguration` widget and the other `AppIntentConfiguration`.

My providers has an optional `var name: String? = nil`, and they are both overridden in the `timelineProvider:` closure. But in the preview, the overridden value only works in the `StaticWidget` not `ConfigurableWidget`.
