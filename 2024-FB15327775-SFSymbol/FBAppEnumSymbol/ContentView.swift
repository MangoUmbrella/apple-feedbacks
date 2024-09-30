//
//  ContentView.swift
//  FBAppEnumSymbol
//
//  Created by Mango Umbrella on 9/29/24.
//

import SwiftUI
import AppIntents

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

enum DiaperType: String, AppEnum {
    case wet = "wet"
    case dirty = "dirty"
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Log Type")
    static var caseDisplayRepresentations: [DiaperType : DisplayRepresentation] = [
        // Case 1 - no images:
        // .wet: DisplayRepresentation(title: "Wet"),
        // .dirty: DisplayRepresentation(title: "Dirty"),
        
        // Case 2 - System SF Symbols:
        // .wet: DisplayRepresentation(title: "Wet", image: .init(systemName: "w.circle")),
        // .dirty: DisplayRepresentation(title: "Dirty", image: .init(systemName: "d.circle")),
        
        // Case 3 - Custom SF Symbols:
        .wet: DisplayRepresentation(title: "Wet", image: .init(named: "custom.w.circle")),
        .dirty: DisplayRepresentation(title: "Dirty", image: .init(named: "custom.d.circle")),
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
