# FB15327775: Custom SF Symbols show large low resolution images in the Shortcuts app

Using the following example App Shortcut:

```swift
enum DiaperType: String, AppEnum {
    case wet = "wet"
    case dirty = "dirty"
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Log Type")
    static var caseDisplayRepresentations: [DiaperType : DisplayRepresentation] = [
        // Case 1 - no images:
        // .wet: DisplayRepresentation(title: "Wet"),
        // .dirty: DisplayRepresentation(title: "Dirty"),
        
        // Case 2 - System SF Symbols:
        // .wet: DisplayRepresentation(title: "Wet", image: .init(systemName: "drop.degreesign.fill")),
        // .dirty: DisplayRepresentation(title: "Dirty", image: .init(systemName: "toilet")),
        
        // Case 3 - Custom SF Symbols:
        .wet: DisplayRepresentation(title: "Wet", image: .init(named: "wet")),
        .dirty: DisplayRepresentation(title: "Dirty", image: .init(named: "dirty")),
    ]
}

struct LogDiaperIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Diaper"
    @Parameter(title: "Diaper Type")
    var diaperType: DiaperType?
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct MyAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(intent: LogDiaperIntent(),
                    phrases: [
                        "\(.applicationName) Log Diaper",
                        "\(.applicationName) Log \(\.$diaperType) Diaper",
                    ],
                    shortTitle: "Log Diaper",
                    systemImageName: "plus.circle")
    ]
}
```

Observe the following behaviors:

1. When the DisplayRepresentation doesn't not define an image, the glyph shows a generic plus with a circular color background in the shortcuts app.
2. When the DisplayRepresentation defines a system SF Symbol, they also show up correctly with the symbol + circular color background.
3. However, when using custom SF Symbols, they simply show up as a large, black, low resolution image in the shortcuts app.

(1) and (2) are expected, but not (3): the custom SF Symbols should show up similar to (1) and (2).
