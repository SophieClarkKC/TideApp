//
//  TidesEntryView.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import WidgetKit
import SwiftUI

/// MARK: - Views

struct TidesEntryView: View {
  @Environment(\.widgetFamily) private var widgetFamily

  var entry: Provider.Entry

  var body: some View {
    switch widgetFamily {
    case .systemSmall, .systemMedium, .systemLarge:
      if entry.data { // TODO: Placeholder, change when data fetch will be implemented
        TidesContentView(entry: entry)
      } else {
        TidesErrorView()
      }
    @unknown default:
      TidesErrorView()
    }
  }
}

/// MARK: - Previews

private struct TideEntryView_Previews: PreviewProvider {
  static var previews: some View {
    TidesEntryView(entry: TidesEntry(data: true,
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))

    TidesEntryView(entry: TidesEntry(data: true,
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemMedium))

    TidesEntryView(entry: TidesEntry(data: true,
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemLarge))

    TidesEntryView(entry: TidesEntry(data: false,
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))

    TidesEntryView(entry: TidesEntry(data: false,
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemMedium))

    TidesEntryView(entry: TidesEntry(data: false,
                                     date: Date(),
                                     configuration: ConfigurationIntent()))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
