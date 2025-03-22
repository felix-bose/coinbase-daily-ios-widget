//
//  widget.swift
//  widget
//
//  Created by Felix Bose on 22.02.25.
//

import WidgetKit
import SwiftUI

struct CoinbaseWidget: Widget {
    let kind: String = "CoinbaseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CoinbaseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Coinbase Widget")
        .description("Displays daily gains and chart.")
        .supportedFamilies([.systemSmall, .systemMedium]) // choose which sizes you want to support
    }
}


struct Provider: TimelineProvider {
    // called when the widget is in loading state
    // TODO add loading animation
    func placeholder(in context: Context) -> PortfolioEntry {
        PortfolioEntry(date: Date(), totalGains: 0.0, chartData: [], lastUpdate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (PortfolioEntry) -> ()) {
            let entry = PortfolioEntry(date: Date(),
                                       totalGains: 123.45,
                                       chartData: [120.0, 121.5, 122.0, 123.45],
                                       lastUpdate: Date())
            completion(entry)
        }

        // Called to provide an actual timeline
        func getTimeline(in context: Context, completion: @escaping (Timeline<PortfolioEntry>) -> ()) {
            // 1. Fetch data from your API (Coinable, etc.)
            fetchPortfolioData { (totalGains, chartData) in
                let currentDate = Date()
                let entry = PortfolioEntry(date: currentDate,
                                           totalGains: totalGains,
                                           chartData: chartData,
                                           lastUpdate: currentDate)
                
                // 2. Create a timeline
                // Refresh every 15min automatically
                let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(nextRefresh))
                
                completion(timeline)
            }
        }
}

