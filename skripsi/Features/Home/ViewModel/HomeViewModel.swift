//
//  HomeViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation
import WatchConnectivity

class HomeViewModel: ObservableObject {
    
    @Published var fetchingTransaction = false
    @Published var currentSortingOption: SortType = .date
    @Published var transactionModel = [TransactionModel]()
    @Published var lastUpdateTimestamp: Date?
    
    let communcationManager = CommunicationManager()
    
    private let getTransactionUseCase = GetTransactionUseCase()
    private let deleteItemTransactionUseCase = DeleteTransactionUseCase()
    
    var incomeTransaction: [Int] {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let currentMonth = Calendar.current.component(.month, from: Date())
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        let todayTransactions = transactionModel.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        let yesterdayTransactions = transactionModel.filter { Calendar.current.isDate($0.date, inSameDayAs: yesterday) }
        let currentMonthTransactions = transactionModel.filter { Calendar.current.component(.month, from: $0.date) == currentMonth }
        let lastMonthTransactions = transactionModel.filter { Calendar.current.component(.month, from: $0.date) == Calendar.current.component(.month, from: lastMonth) }
        
        let todayIncome = todayTransactions.reduce(0) { $0 + $1.totalTransaction }
        let yesterdayIncome = yesterdayTransactions.reduce(0) { $0 + $1.totalTransaction }
        
        let currentOmzet = currentMonthTransactions.flatMap { $0.items.map { $0.totalOmzetPerItem } }.reduce(0, +)
        let previousOmzet = lastMonthTransactions.flatMap { $0.items.map { $0.totalOmzetPerItem } }.reduce(0, +)
        
        let currentProfit = currentMonthTransactions.flatMap { $0.items.map { $0.totalProfitPerItem } }.reduce(0, +)
        let previousProfit = lastMonthTransactions.flatMap { $0.items.map { $0.totalProfitPerItem } }.reduce(0, +)
        
        return [todayIncome, yesterdayIncome, currentOmzet, previousOmzet, currentProfit, previousProfit]
    }
    
    func getTransactions() {
        Task {
            DispatchQueue.main.sync {
                self.fetchingTransaction = true
            }
            
            let result = await getTransactionUseCase.execute(params: GetTransactionUseCase.Params())
            switch result {
            case .success(let transaction):
                DispatchQueue.main.sync {
                    self.transactionModel = transaction
                    self.sortTransactions()
                    self.fetchingTransaction = false
                    
                    let incomeTransaction = self.incomeTransaction
                    communcationManager.sendTodayIncome(incomeTransaction)
                    
                    self.lastUpdateTimestamp = Date()
                }
                break
            case .failure(let error):
                print("Error fetching transaction: \(error)")
                DispatchQueue.main.sync {
                    self.fetchingTransaction = false
                }
                break
            }
        }
    }
    
    func deleteTransaction(transactionId: String) {
        Task {
            DispatchQueue.main.sync {
                self.fetchingTransaction = true
            }
            let result = await deleteItemTransactionUseCase.execute(params: DeleteTransactionUseCase.Param(transactionId: transactionId))
            switch result {
            case .success :
                DispatchQueue.main.sync {
                    self.getTransactions()
                    self.fetchingTransaction = false
                }
                break
            case .failure(let error):
                print("Error \(error)")
                DispatchQueue.main.sync {
                    self.fetchingTransaction = false
                }
                break
            }
        }
    }
    
    func changeSortType(to sortType: SortType) {
        currentSortingOption = sortType
        sortTransactions()
    }
    
    private func sortTransactions() {
        switch currentSortingOption {
        case .cashier:
            transactionModel.sort { $0.cashier < $1.cashier }
        case .orderNumber:
            transactionModel.sort { $0.orderNumber < $1.orderNumber }
        case .date:
            transactionModel.sort { $0.date > $1.date }
        }
    }
}

enum SortType: String, CaseIterable, Identifiable {
    case cashier = "Cashier"
    case orderNumber = "Order"
    case date = "Date"
    var id: SortType { self }
}
