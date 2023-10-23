//
//  skripsiApp.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

@main
struct skripsiApp: App {
    
    @ObservedObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .detailTransaction:
                            DetailHistoryView()
                        case .pay:
                            PayView()
                        case .scan:
                            ScanView()
                        }
                    }
                    .environmentObject(router)
            }
            
        }
    }
}
