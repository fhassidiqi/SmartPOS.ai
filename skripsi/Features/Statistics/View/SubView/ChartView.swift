//
//  ChartView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    let transactionModel: [TransactionModel]
    @State var revenueChart: RevenueType = .omzet
    @StateObject private var vm = StatisticViewModel()
    
    var xAxisValues: [String] {
        transactionModel
            .sorted(by: { $0.date < $1.date })
            .map { $0.date.formatToMonth }
    }
    
        var yAxisValues: [Int] = [0, 1000000, 2000000, 3000000, 4000000]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("REVENUE")
                    .font(.headline).bold()
                    .foregroundStyle(Color.text.primary100)
                
                Spacer()
                // TODO: Create Picker
                
            }
            .foregroundStyle(Color.text.primary30)
            
            HStack(spacing: 16) {
                Picker("Revenue Type", selection: $revenueChart) {
                    Text("Omzet").tag(RevenueType.omzet)
                    Text("Profit").tag(RevenueType.profit)
                }
                .pickerStyle(.segmented)
            }
            
            Chart(transactionModel.sorted(by: { $0.date < $1.date })) { transactionModel in
                ForEach(transactionModel.items, id: \.self) { transaction in
                    BarMark(
                        x: .value("Month", transactionModel.date.formatToMonth),
                        y: .value(revenueChart == .omzet ? "Omzet" : "Profit",
                                  revenueChart == .omzet ? transaction.totalOmzetPerItem : transaction.totalProfitPerItem),
                        width: 10
                    )
                    .foregroundStyle(revenueChart == .omzet ? Color.secondaryColor : Color.tertiaryColor)
                }
                
                RuleMark(y: .value("Target", revenueChart == .omzet ? 3500000 : 2500000))
                    .foregroundStyle(Color.mint)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    .annotation(alignment: .leading) {
                        Text("Target")
                            .font(.caption)
                            .foregroundStyle(Color.text.primary100)
                    }
            }
            .frame(height: 180)
            .chartYScale(domain: 0...5000000)
            .chartYAxis {
                AxisMarks(position: .leading, values: yAxisValues) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 1))
                    AxisValueLabel() {
                        if let intValue = value.as(Int.self) {
                            Text(intValue.formattedYAxisLabel)
                                .font(.caption)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(position: .bottom, values: xAxisValues)
            }
        }
        .padding()
        .background(Color.background.base)
    }
}

enum RevenueType {
    case omzet
    case profit
}
