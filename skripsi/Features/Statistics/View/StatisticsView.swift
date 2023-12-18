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
    @ObservedObject var vm: StatisticViewModel
    
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
                                Text(selectedDate.formatMonthAndYear)
                                    .font(.footnote)
                                
                                Image(systemName: "arrowtriangle.down.fill")
                                    .resizable()
                                    .frame(width: 15, height: 10)
                            }
                        }
                    }
                    .foregroundColor(Color.text.primary100)
                    
                    HStack(spacing: 16) {
                        if vm.fetchingOmzetData && vm.fetchingProfitData {
                            ForEach(0..<2) { _ in
                                Rectangle()
                                    .frame(width: 140, height: 100)
                                    .padding()
                                    .foregroundColor(.black.opacity(0.2))
                                    .cornerRadius(20)
                                    .shimmer()
                            }
                        } else {
                            ForEach(["Omzet", "Profit"], id: \.self) { title in
                                if title == "Omzet" {
                                    RevenueCardView(title: title, currentValue: vm.omzetInMonth, previousValue: vm.omzetPreviousMonth, percentageChange: vm.omzetPercentage)
                                } else {
                                    RevenueCardView(title: title, currentValue: vm.profitInMonth, previousValue: vm.profitPreviousMonth, percentageChange: vm.profitPercentage)
                                }
                            }
                        }
                    }
                    
                    ChartView(transactionModel: vm.transactionModel)
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
        .onAppear {
            Task {
                await vm.updateData(for: selectedDate)
                await vm.calculateTotalOmzet(forMonth: selectedDate)
                await vm.calculateTotalProfit(forMonth: selectedDate)
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            MonthYearPickerView(selectedDate: $selectedDate, isPickerPresented: $isPickerPresented) {
                Task {
                    await vm.updateData(for: selectedDate)
                }
            }
            .presentationDetents([.medium, .large], selection: $settingsDetent)
        }
    }
}

struct MonthYearPickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPickerPresented: Bool
    @State private var selectedDateTemp: Date
    var onSave: () -> Void
    
    init(selectedDate: Binding<Date>, isPickerPresented: Binding<Bool>, onSave: @escaping () -> Void) {
        self._selectedDate = selectedDate
        self._isPickerPresented = isPickerPresented
        self._selectedDateTemp = State(initialValue: selectedDate.wrappedValue)
        self.onSave = onSave
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
                            onSave()
                        }, label: {
                            Text("Save")
                        })
                    }
                }
        }
    }
}
