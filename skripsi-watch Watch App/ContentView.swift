//
//  ContentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayRevenueView()
                .tag(0)
            
            MonthlyRevenueView()
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
