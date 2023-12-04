//
//  StatisticsView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct StatisticsView: View {
    
    @State private var selectedDate = Date()
    @State private var isPickerPresented = false
    @State private var settingsDetent = PresentationDetent.medium
    @StateObject var vm = StatisticViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.primary
                    .edgesIgnoringSafeArea(.top)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Overview")
                            .font(.largeTitle).bold()
                        
                        HStack(spacing: 5) {
                            Text("Show:")
                                .font(.footnote)
                                .foregroundStyle(Color.text.primary30)
                            
                            Button {
                                isPickerPresented.toggle()
                            } label: {
                                Text(formattedDate(selectedDate))
                                    .font(.footnote)
                                
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 15, height: 10)
                            }
                        }
                    }
                    .foregroundColor(Color.text.primary100)
                    
                    HStack(spacing: 16) {
                        let currentMonthRevenue = vm.totalRevenue(forMonth: selectedDate)
                        let previousMonthRevenue = vm.totalRevenue(forMonth: Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date())
                        
                        RevenueCardView(title: "Omzet", value: currentMonthRevenue, previousMonthValue: previousMonthRevenue)
                        
                        let currentMonthProfit = vm.totalProfit(forMonth: selectedDate)
                        let previousMonthProfit = vm.totalProfit(forMonth: Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date())
                        
                        RevenueCardView(title: "Profit", value: currentMonthProfit, previousMonthValue: previousMonthProfit)
                    }
                    
                    ChartView()
                        .cornerRadius(20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            .toolbar {
                ToolbarItem (placement: .principal) {
                    Text("Statistics")
                        .font(.headline)
                        .foregroundStyle(Color.text.white)
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarBackground(Color.primary100, for: .automatic)
        }
        .sheet(isPresented: $isPickerPresented) {
            MonthYearPickerView(selectedDate: $selectedDate, isPickerPresented: $isPickerPresented)
                .presentationDetents([.medium, .large], selection: $settingsDetent)
        }
        .onAppear {
            vm.getTransactions()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    StatisticsView()
}

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPickerPresented: Bool
    @State private var selectedDateTemp: Date
    
    init(selectedDate: Binding<Date>, isPickerPresented: Binding<Bool>) {
        self._selectedDate = selectedDate
        self._isPickerPresented = isPickerPresented
        self._selectedDateTemp = State(initialValue: selectedDate.wrappedValue)
    }
    
    var body: some View {
        NavigationStack {
            DatePicker("", selection: $selectedDateTemp, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            selectedDate = selectedDateTemp
                            isPickerPresented = false
                        }, label: {
                            Text("Save")
                        })
                    }
                }
        }
    }
}
