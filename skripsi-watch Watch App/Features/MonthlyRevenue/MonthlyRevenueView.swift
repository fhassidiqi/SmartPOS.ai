
//
//  MonthlyRevenueView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct MonthlyRevenueView: View {
    
    @EnvironmentObject var vm: WatchViewModel
    @StateObject private var comManager = CommunicationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base
                    .ignoresSafeArea()

                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ReportView(
                                title: "Omzet",
                                current: vm.currentMonthOmzet.formattedAsAbbreviation,
                                percentage: vm.percentageChange(current: vm.currentMonthOmzet, previous: vm.previousMonthOmzet),
                                comparison: "Compared to Last Month (\(vm.previousMonthOmzet.formattedAsAbbreviation))"
                            )

                            ReportView(
                                title: "Profit",
                                current: vm.currentMonthProfit.formattedAsAbbreviation,
                                percentage: vm.percentageChange(current: vm.currentMonthProfit, previous: vm.previousMonthProfit),
                                comparison: "Compared to Last Month (\(vm.previousMonthProfit.formattedAsAbbreviation))"
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
    }
}
