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
        NavigationStack(path: $vm.navigationPath) {
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
            .navigationDestination(for: RouteType.self) {type in
                if type == .detail {
                    DetailHistoryView()
                        
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
