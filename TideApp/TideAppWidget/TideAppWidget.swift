//
//  TideAppWidget.swift
//  TideAppWidget
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> TidesEntry {
    TidesEntry(data: true,
               date: Date(),
               configuration: ConfigurationIntent())
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (TidesEntry) -> ()) {
    let entry = TidesEntry(
      data: true,
      date: Date(),
      configuration: configuration)
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<TidesEntry>) -> ()) {
    var entries: [TidesEntry] = []

    let entry = TidesEntry(
      data: true,
      date: Date(),
      configuration: configuration)
    entries.append(entry)

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

@main
struct TideAppWidget: Widget {
  let kind: String = "TideAppWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      TidesEntryView(entry: entry)
    }
    .configurationDisplayName("Tide App Widget")
    .description("Widget to retrieve informations about tides")
  }
}
