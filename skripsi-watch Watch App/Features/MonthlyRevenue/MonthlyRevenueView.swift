
//
//  MonthlyRevenueView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct MonthlyRevenueView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.base

                ScrollView {
                    ScrollViewReader { scrollViewProxy in
                        VStack {
                            ReportView(
                                title: "Omzet",
                                current: 5000000,
                                previous: 3000000,
                                percentage: 20.2
                            )

                            ReportView(
                                title: "Profit",
                                current: 4000000,
                                previous: 2500000,
                                percentage: 20.2
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
                    
                }
            }
        }
        
    }
}

#Preview {
    MonthlyRevenueView()
}
