# FB15506259: Certain App Shortcuts parameterized phrases cannot be recognized with the concrete parameter

I have the following App Intent and AppShortcut:

```swift
enum DiaperType: String, AppEnum {
    case wet = "Wet"
    case dirty = "Dirty"

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Diaper Type")
    static var caseDisplayRepresentations: [DiaperType : DisplayRepresentation] = [
        .wet: DisplayRepresentation(title: "Wet"),
        .dirty: DisplayRepresentation(title: "Dirty"),
    ]
}

struct LogDiaperAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Log Diaper"
    static var parameterSummary: some ParameterSummary {
        Summary("Log \(\.$diaperType) diaper")
    }
    
    @Parameter(title: "Diaper Type", requestValueDialog: IntentDialog("Diaper is wet or dirty?"))
    var diaperType: DiaperType
    
    func perform() async throws -> some ShowsSnippetView {
        return .result() {
            Text("\(self.diaperType) diaper logged")
        }
    }
}

@available(iOSApplicationExtension, unavailable)
extension LogDiaperAppIntent: ForegroundContinuableIntent {}

struct MyAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: LogDiaperAppIntent(),
            phrases: [
                "\(.applicationName) Log Diaper",
                "\(.applicationName) Log \(\.$diaperType) Diaper",
                "\(.applicationName) \(\.$diaperType) Diaper",
            ],
            shortTitle: "Log Diaper",
            systemImageName: "plus.circle"
        ),
    ]
}
```

Calling out the three phrases I have configured:

```swift
    "\(.applicationName) Log Diaper",
    "\(.applicationName) Log \(\.$diaperType) Diaper",
    "\(.applicationName) \(\.$diaperType) Diaper",
```

When I say the following to Siri (or use type to Siri with the exact words), it can correctly recognize the `$diaperType` parameter:

1. Demo dirty diaper
2. Demo wet diaper

However, when I use the "Demo log $diaperType diaper" variant, it fails to recognize the parameter and always prompts me to input the `$diaperType`:

1. Demo log dirty diaper
2. Demo log wet diaper

This is the same as if I just said "Demo log diaper" without the parameter.

Additional info in case it's useful:

1. I think this issue started happening since iOS 17.
2. Xcode Version: 16.0 (16A242d)
