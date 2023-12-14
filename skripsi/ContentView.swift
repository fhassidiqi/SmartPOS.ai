//
//  ContentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var router: Router
    @State private var selectedTab = "transaction"
    @StateObject private var vm = StatisticViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(router)
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        Image(systemName: "house")
                    }
                }
                .tag("home")
            
            FoodListView()
                .environmentObject(router)
                .tabItem {
                    Label {
                        Text("Transaction")
                    } icon: {
                        Image(systemName: "cart")
                            .resizable()
                    }
                }
                .tag("transaction")
            
            StatisticsView(vm: vm)
                .environmentObject(router)
                .tabItem {
                    Label {
                        Text("Statistics")
                    } icon: {
                        Image(systemName: "chart.bar")
                    }
                }
                .tag("statistics")
        }
    }
}

#Preview {
    ContentView()
}
