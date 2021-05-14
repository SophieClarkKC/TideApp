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
  private let dataProvider: TidesWidgetDataProviderType

  init(dataProvider: TidesWidgetDataProviderType) {
    self.dataProvider = dataProvider
  }

  func placeholder(in context: Context) -> TidesEntry {
    return TidesEntry.snapshotObject()
  }

  func getSnapshot(for configuration: WidgetConfigurationIntent, in context: Context, completion: @escaping (TidesEntry) -> ()) {
    completion(TidesEntry.snapshotObject())
  }

  func getTimeline(for configuration: WidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<TidesEntry>) -> ()) {
    dataProvider.retrieveData(for: configuration) { widgetData in
      let entry = TidesEntry(widgetData: widgetData,
                             date: Date(),
                             configuration: configuration)
      let fiveMinutesDate = Date().addingTimeInterval(360)
      let timeline = Timeline(entries: [entry],
                              policy: .after(fiveMinutesDate))
      completion(timeline)
    }
  }
}

@main
struct TideAppWidget: Widget {
  let kind: String = "TideAppWidget"
  let dataProvider = TidesWidgetDataProvider(weatherFetcher: WeatherDataFetcher())

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind,
                        intent: WidgetConfigurationIntent.self,
                        provider: Provider(dataProvider: dataProvider)) { entry in
      TidesEntryView(entry: entry)
    }
    .configurationDisplayName("Tide App Widget")
    .description("Widget to retrieve informations about tides")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}
