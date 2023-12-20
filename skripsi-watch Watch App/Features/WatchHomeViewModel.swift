//
//  WatchHomeViewModel.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import Foundation
import WatchConnectivity

final class WatchHomeViewModel: NSObject, ObservableObject, WCSessionDelegate {
    
    @Published var selectedTransaction: TransactionModel?
    @Published var transactionModel = [TransactionModel]()
    
    private let session: WCSession = .default
    
    var todayIncome: String {
        let today = Date()
        let filteredTransactions = transactionModel.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        let totalIncome = filteredTransactions.reduce(0) { $0 + $1.totalTransaction }
        let formattedIncome = NumberFormatter.localizedString(from: NSNumber(value: totalIncome), number: .currency)
        return formattedIncome
    }
    
    override init() {
        super.init()
        self.selectedTransaction = selectedTransaction
        self.transactionModel = transactionModel
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func fetchTransaction() {
        session.sendMessage(["fetchTransaction": true], replyHandler: nil, errorHandler: nil)
    }
}
