//
//  TodayRevenueView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct TodayRevenueView: View {
    
    @EnvironmentObject var vm: WatchViewModel
    @StateObject private var comManager = CommunicationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base
                    .ignoresSafeArea()
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        ReportView(
                            title: "Today's Income",
                            current: vm.todayIncome.formattedAsAbbreviation,
                            percentage: vm.percentageChange(current: vm.todayIncome, previous: vm.yesterdayIncome),
                            comparison: "Compared to Yesterday (\(vm.yesterdayIncome.formattedAsAbbreviation))"
                        )
                    }
                }
                .tabViewStyle(.page)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Daily Report")
                        .font(.headline)
                        .foregroundStyle(Color.text.titleWatch)
                }
            }
        }
        .onReceive(comManager.dataSubject) { data in
            vm.todayIncome = data[0]
            vm.yesterdayIncome = data[1]
            vm.currentMonthOmzet = data[2]
            vm.previousMonthOmzet = data[3]
            vm.currentMonthProfit = data[4]
            vm.previousMonthProfit = data[5]
        }
    }
}
