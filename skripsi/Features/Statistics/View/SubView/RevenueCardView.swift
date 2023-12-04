//
//  ChartView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isPickerPresented = false
    @State private var settingsDetent = PresentationDetent.height(200)
    
    let viewMonth: [ViewMonth] = [
        .init(date: Date.from(year: 2023, month: 1, day: 1), omzet: 25000000, profit: 3000000),
        .init(date: Date.from(year: 2023, month: 2, day: 1), omzet: 27000000, profit: 10500000),
        .init(date: Date.from(year: 2023, month: 3, day: 1), omzet: 23000000, profit: 2900000),
        .init(date: Date.from(year: 2023, month: 4, day: 1), omzet: 35000000, profit: 5000000),
        .init(date: Date.from(year: 2023, month: 5, day: 1), omzet: 20000000, profit: 10000000),
        .init(date: Date.from(year: 2023, month: 6, day: 1), omzet: 25700000, profit: 7500000),
    ]
    let yAxisLable: [Int] = [0, 10000000, 20000000, 30000000, 40000000, 50000000]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            titleAndDate
            
            HStack(spacing: 16) {
                typeRevenue(title: "Omzet", color: Color.secondary100)
                typeRevenue(title: "Profit", color: Color.tertiaryColor)
            }
            barChart
        }
        .padding()
        .background(Color.background.base)
    }
}

#Preview {
    ChartView()
}

struct ViewMonth: Identifiable {
    let id = UUID()
    let date: Date
    let omzet: Int
    let profit: Int
}

extension ChartView {
    private var titleAndDate: some View {
        HStack {
            Text("REVENUE")
                .font(.headline).bold()
                .foregroundStyle(Color.text.primary100)
            
            Spacer()
            
            Button {
                isPickerPresented.toggle()
            } label: {
                Text(formattedDate(startDate, endDate))
                    .font(.footnote)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 15, height: 10)
            }
            
        }
        .foregroundStyle(Color.text.primary30)
        .sheet(isPresented: $isPickerPresented) {
            RangePickerView(startDate: $startDate, endDate: $endDate, isPickerPresented: $isPickerPresented)
                .presentationDetents([.height(200), .medium, .large], selection: $settingsDetent)
        }
    }
    
    private func typeRevenue(title: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundStyle(color)
            
            Text(title)
                .font(.footnote)
        }
    }
    
    private var barChart: some View {
        Chart {
            RuleMark(y: .value("Target", 30000000))
                .foregroundStyle(Color.mint)
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .annotation(alignment: .leading) {
                    Text("Target")
                        .font(.caption)
                        .foregroundStyle(Color.text.primary100)
                }
            
            ForEach(viewMonth) { viewMonth in
                // "Omzet" bar
                BarMark(x: .value("Month", viewMonth.date, unit: .month),
                        y: .value("Revenue", viewMonth.omzet), width: 10)
                .foregroundStyle(Color.secondaryColor)
                
                // "Profit" bar
                BarMark(x: .value("Month", viewMonth.date, unit: .month),
                        y: .value("Profit", viewMonth.profit), width: 10)
                .foregroundStyle(Color.tertiaryColor)
                
                
            }
            
        }
        .frame(height: 180)
        .chartYScale(domain: 0...50000000)
        .chartXAxis {
            AxisMarks(values: viewMonth.map { $0.date }){ date in
                AxisValueLabel(format: .dateTime.month(.abbreviated), centered: true)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: yAxisLable)
        }
        
    }
    
    func formattedDate(_ startDate: Date, _ endDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return "\(dateFormatter.string(from: startDate)) - \(dateFormatter.string(from: endDate))"
    }
}

struct RangePickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var isPickerPresented: Bool
    @State private var selectedFirstDate: Date
    @State private var selectedEndDate: Date
    
    init(startDate: Binding<Date>, endDate: Binding<Date>, isPickerPresented: Binding<Bool>) {
        self._startDate = startDate
        self._endDate = endDate
        self._isPickerPresented = isPickerPresented
        self._selectedFirstDate = State(initialValue: startDate.wrappedValue)
        self._selectedEndDate = State(initialValue: endDate.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                DatePicker("", selection: $selectedFirstDate, displayedComponents: .date)
                Text("-")
                DatePicker("", selection: $selectedEndDate, displayedComponents: .date)
            }
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        startDate = selectedFirstDate
                        endDate = selectedEndDate
                        isPickerPresented = false
                    }, label: {
                        Text("Save")
                    })
                }
            }
        }
    }
}

