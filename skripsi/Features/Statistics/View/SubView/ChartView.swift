//
//  ChartView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @State var selectedDateRange1: Date
    @State var selectedDateRange2: Date
    @StateObject private var vm = StatisticViewModel()
    let yAxisLabel: [Int] = [0, 100000, 200000, 300000, 400000, 500000]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("REVENUE")
                    .font(.headline).bold()
                    .foregroundStyle(Color.text.primary100)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text(formattedDate(selectedDateRange1, selectedDateRange2))
                        .font(.footnote)
                    
                    Image(systemName: "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 15, height: 10)
                }
                
            }
            .foregroundStyle(Color.text.primary30)
            
            HStack(spacing: 16) {
                HStack(spacing: 5) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.secondary100)
                    
                    Text("Omzet")
                        .font(.footnote)
                }
                HStack(spacing: 5) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(Color.tertiaryColor)
                    
                    Text("Profit")
                        .font(.footnote)
                }
            }
            
            Chart {
                RuleMark(y: .value("Target", 300000))
                    .foregroundStyle(Color.mint)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Target")
                            .font(.caption)
                            .foregroundStyle(Color.text.primary100)
                    }
                
                ForEach(vm.monthlyOmzetTotals.sorted(by: { $0.key < $1.key }), id: \.key) { month, omzet in
                    // "Omzet" bar
                    BarMark(x: .value("Month", month, unit: .month),
                            y: .value("Revenue", omzet), width: 10)
                    .foregroundStyle(Color.secondaryColor)
                }
            }
            .frame(height: 180)
            .chartYScale(domain: 0...500000)
            .chartXAxis {
                AxisMarks(values: vm.monthlyOmzetTotals.keys.sorted()) { month in
                    AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: yAxisLabel)
            }
        }
        .padding()
        .background(Color.background.base)
        .onAppear {
            Task {
                await vm.calculateTotalOmzetForMonths(dateRange: selectedDateRange1...selectedDateRange2)
            }
        }
    }
}

extension ChartView {
    
    func formattedDate(_ startDate: Date, _ endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}
