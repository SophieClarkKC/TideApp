//
//  TidesEntry.swift
//  TideApp
//
//  Created by Marco Guerrieri on 10/05/2021.
//

import WidgetKit

struct TidesEntry: TimelineEntry {
  let data: Bool // TODO: Placeholder for data that will fulfill the widget, false means error, replace when data fetching will be implemented
  let date: Date
  let configuration: ConfigurationIntent
}
