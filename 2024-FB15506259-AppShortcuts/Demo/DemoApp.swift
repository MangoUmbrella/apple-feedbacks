import SwiftUI
import AppIntents

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

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}
