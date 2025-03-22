//
//  CoinbaseWidgetEntryView.swift
//  CoinbaseDaily
//
//  Created by Felix Bose on 22.02.25.
//

import WidgetKit
import SwiftUI

struct CoinbaseWidgetEntryView: View {
    var entry: Provider.Entry


    var body: some View {
        // For a small widget, you might keep it concise
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // top row with chart and icon
                    // Chart
                    if !entry.chartData.isEmpty {
                        ChartView(data: entry.chartData)
                            .frame(height: 40)
                    } else {
                        Text("No Chart Data")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                    Spacer()
                    
                    Image("coinbase-logo")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                // Gains/loss
                Text("\(entry.totalGains >= 0 ? "+" : "")\(entry.totalGains, specifier: "%.2f") €")
                    .font(.headline)
                    .foregroundColor(entry.totalGains >= 0 ? Color(red:0.0, green: 82.0/255.0, blue: 1.0, opacity: 1) : .red)
                
                // Last update
                Text(relateDateString(for: entry.lastUpdate))
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
    
    func relateDateString(for date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct PortfolioEntry: TimelineEntry {
    let date: Date
    let totalGains: Double
    let chartData: [Double] // or a custom struct
    let lastUpdate: Date
}


struct CoinbaseWidgetEntryView_Preview: PreviewProvider {
    static var previews: some View {
        CoinbaseWidgetEntryView(entry: PortfolioEntry(
            date: Date(),
            totalGains: 30.78,
            chartData: [29.0, 31.2, 30.5, 30.78, 29.0, 22.1,22,4,15.0,42],
            lastUpdate: Date().addingTimeInterval(-60)
        ))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
        .containerBackground(for: .widget){
            LinearGradient(
               gradient: Gradient(colors: [
                   Color.black.opacity(0.65),
                   Color.black
               ]),
               startPoint: .top,
               endPoint: .bottom
            ).ignoresSafeArea()
        }
    }
}
