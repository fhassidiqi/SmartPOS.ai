//
//  ContentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @StateObject private var vm = WatchViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayRevenueView()
                .environmentObject(vm)
                .tag(0)
            
            MonthlyRevenueView()
                .environmentObject(vm)
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
