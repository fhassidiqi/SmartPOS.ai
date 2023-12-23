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
    @State private var todayIncome: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base
                
                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        ReportView(
                            title: "Income",
                            current: todayIncome,
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
        .onReceive(comManager.dataSubject) { data in
            todayIncome = data
            print("Data received: \(data)")
        }
    }
}

#Preview {
    TodayRevenueView()
}
