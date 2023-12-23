//
//  TodayRevenueView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct TodayRevenueView: View {
    
    @State private var selectedTab = 0
    @StateObject private var comManager = CommunicationManager()
    @StateObject private var vm = WatchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        ReportView(
                            title: "Today's Income",
                            current: vm.todayIncome.formattedAsAbbreviation,
                            previous: vm.yesterdayIncome.formattedAsAbbreviation,
                            percentage: vm.percentageChange(current: vm.todayIncome, previous: vm.yesterdayIncome)
                        )
                    }
                }
                .tabViewStyle(.page)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Daily Report")
                        .font(.headline)
                    
                }
            }
        }
        .onReceive(comManager.dataSubject) { data in
            vm.todayIncome = data[0]
            vm.yesterdayIncome = data[1]
            print("Data received: \(data)")
        }
    }
}

#Preview {
    TodayRevenueView()
}
