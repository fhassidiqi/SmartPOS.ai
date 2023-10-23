//
//  ContentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            TabView {
                HomeView()
                    .environmentObject(vm)
                    .tabItem {
                        Label {
                            Text("Home")
                        } icon: {
                            Image(systemName: "house")
                        }
                    }
                
                FoodListView()
                    .environmentObject(vm)
                    .tabItem {
                        Label {
                            Text("Transaction")
                        } icon: {
                            Image(systemName: "cart")
                                .resizable()
                        }
                    }
                
                StatisticsView()
                    .environmentObject(vm)
                    .tabItem {
                        Label {
                            Text("Statistics")
                        } icon: {
                            Image(systemName: "chart.bar")
                        }
                    }
            }
//            .navigationDestination(for: RouteType.self) {type in
//                switch type {
//                case .detail:
//                    DetailHistoryView()
//                case .foodList:
//                    FoodListView()
//                case .pay:
//                    PayView()
//                case .statistics:
//                    StatisticsView()
//                }
//            }
        }
    }
}

#Preview {
    ContentView()
}
