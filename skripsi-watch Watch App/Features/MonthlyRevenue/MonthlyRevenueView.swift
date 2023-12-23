
//
//  MonthlyRevenueView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct MonthlyRevenueView: View {
    
    @StateObject private var comManager = CommunicationManager()
    @StateObject private var vm = WatchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base

                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ReportView(
                                title: "Omzet",
                                current: vm.currentMonthOmzet.formattedAsAbbreviation,
                                previous: vm.previousMonthOmzet.formattedAsAbbreviation,
                                percentage: vm.percentageChange(current: vm.currentMonthOmzet, previous: vm.previousMonthOmzet)
                            )

                            ReportView(
                                title: "Profit",
                                current: vm.currentMonthProfit.formattedAsAbbreviation,
                                previous: vm.previousMonthProfit.formattedAsAbbreviation,
                                percentage: vm.percentageChange(current: vm.currentMonthProfit, previous: vm.previousMonthProfit)
                            )
                        }
                    }
                }
                .tabViewStyle(.page)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Monthly Report")
                        .font(.headline)
                        .foregroundStyle(Color.text.titleWatch)
                }
            }
        }
        .onReceive(comManager.dataSubject) { data in
            vm.currentMonthOmzet = data[2]
            vm.previousMonthOmzet = data[3]
            vm.currentMonthProfit = data[4]
            vm.previousMonthProfit = data[5]
        }
    }
}

#Preview {
    MonthlyRevenueView()
}
