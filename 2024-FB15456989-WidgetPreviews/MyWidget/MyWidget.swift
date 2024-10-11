//
//  MyWidget.swift
//  MangoWidgetPreviews
//
//  Created by Mango Umbrella on 10/9/24.
//

import Foundation
import SwiftUI
import WidgetKit
import AppIntents

struct MyView: View {
    let entry: MyEntry
    
    var body: some View {
        VStack {
            Text(self.entry.color ?? "Red")
        }
        .containerBackground(.clear, for: .widget)
    }
}

struct MyEntry: TimelineEntry {
    let date: Date
    let color: String?
}

struct MyWidgetConfiguration: AppIntent, WidgetConfigurationIntent {
    static var isDiscoverable: Bool { false }
    static var title: LocalizedStringResource = "Mango's Widget"
}

struct IntentProvider: AppIntentTimelineProvider {
    var name: String? = nil
    
    func placeholder(in context: Context) -> MyEntry {
        MyEntry(date: Date(), color: self.name)
    }
    func snapshot(for configuration: MyWidgetConfiguration, in context: Context) async -> MyEntry {
        return MyEntry(date: Date(), color: self.name)
    }
    func timeline(for configuration: MyWidgetConfiguration, in context: Context) async -> Timeline<MyEntry> {
        return Timeline(entries: [MyEntry(date: Date(), color: self.name)], policy: .atEnd)
    }
}

struct StaticProvider: TimelineProvider {
    var name: String? = nil
    
    func placeholder(in context: Context) -> MyEntry {
        MyEntry(date: Date(), color: self.name)
    }
    func getSnapshot(in context: Context, completion: @escaping @Sendable (MyEntry) -> Void) {
        completion(MyEntry(date: Date(), color: self.name))
    }
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<MyEntry>) -> Void) {
        completion(Timeline(entries: [MyEntry(date: Date(), color: self.name)], policy: .atEnd))
    }
}

struct ConfigurableWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "configurable-widget",
                               intent: MyWidgetConfiguration.self,
                               provider: IntentProvider()) { entry in
                MyView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
    }
    
}

struct StaticWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "static-widget",
                            provider: StaticProvider()) { entry in
                MyView(entry: entry)
        }
        .supportedFamilies([.systemSmall])
    }
    
}

#if DEBUG
#Preview("StaticWidget", as: .systemSmall) {
    StaticWidget()
} timelineProvider: {
    var provider = StaticProvider()
    // This works as expected, the preview shows "Orange" instead of the default "Red".
    provider.name = "Orange"
    return provider
}

#Preview("ConfigurableWidget", as: .systemSmall, using: MyWidgetConfiguration()) {
    ConfigurableWidget()
} timelineProvider: {
    var provider = IntentProvider()
    // BUG: This has no effect.
    provider.name = "Orange"
    return provider
}
#endif
