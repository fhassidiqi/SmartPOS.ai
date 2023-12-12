//
//  Router.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/11/23.
//

import SwiftUI

@MainActor
final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case scanQR
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    
    func navigateToDetailTransaction(transaction: TransactionModel) {
        navPath.append(transaction)
    }
    
    func navigateToPayment(transaction: [ItemTransactionModel]) {
        navPath.append(transaction)
    }
}
