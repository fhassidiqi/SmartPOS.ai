//
//  skripsiApp.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct skripsiApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject private var router = Router()
    @StateObject private var vm = FoodListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath){
                ContentView()
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case .cameraView:
                            CameraView()
                        case .FoodListView:
                            FoodListView()
                        case .scanQR:
                            ScanQRView()
                        }
                    }
                    .navigationDestination(for: TransactionModel.self) { transaction in
                        DetailHistoryView(transactionModel: transaction)
                    }
                    .navigationDestination(for: [ItemTransactionModel].self) { itemTransaction in
                        PaymentView()
                            .environmentObject(vm)
                    }
            }
            .environmentObject(router)
            .environmentObject(vm)
        }
    }
}
