//
//  ChartView.swift
//  CoinbaseDaily
//
//  Created by Felix Bose on 22.02.25.
//

import SwiftUI
import Charts

// TODO use swift charts
struct ChartView: View {
    let data: [Double]

    var body: some View {
            Chart {
                RuleMark(y: .value("Zero", 0))
                                .lineStyle(StrokeStyle(lineWidth: 1))
                                .foregroundStyle(Color.gray.opacity(0.5))
                ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(Color(red: 0.0, green: 82.0/255.0, blue: 1.0))
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
        
            .chartXAxis {
                AxisMarks(preset: .aligned, values: .automatic)
            }
        }
}
