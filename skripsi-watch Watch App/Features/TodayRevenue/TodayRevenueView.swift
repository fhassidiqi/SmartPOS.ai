//
//  TodayRevenueView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct TodayRevenueView: View {
    
    @State private var selectedTab = 0
    @StateObject private var vm = WatchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        ReportView(
                            title: "Income",
                            current: Int(vm.todayIncome) ?? 0,
                            previous: 3000000,
                            percentage: 20.2
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
    }
}

#Preview {
    TodayRevenueView()
}
