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
    switch entry.widgetData {
    case .success:
      switch widgetFamily {
      case .systemSmall, .systemMedium, .systemLarge:
        TidesContentView(entry: entry)
      default:
        TidesErrorView()
      }
    case .failure:
      TidesErrorView()
    }
  }
}

/// MARK: - Previews

private struct TideEntryView_Previews: PreviewProvider {
  static var previews: some View {
    TidesEntryView(entry: TidesEntry.snapshotObject(onError: false))
      .previewContext(WidgetPreviewContext(family: .systemSmall))

    TidesEntryView(entry: TidesEntry.snapshotObject(onError: false))
      .previewContext(WidgetPreviewContext(family: .systemMedium))

    TidesEntryView(entry: TidesEntry.snapshotObject(onError: false))
      .previewContext(WidgetPreviewContext(family: .systemLarge))

    TidesEntryView(entry: TidesEntry.snapshotObject(onError: true))
      .previewContext(WidgetPreviewContext(family: .systemSmall))

    TidesEntryView(entry: TidesEntry.snapshotObject(onError: true))
      .previewContext(WidgetPreviewContext(family: .systemMedium))

    TidesEntryView(entry: TidesEntry.snapshotObject(onError: true))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
