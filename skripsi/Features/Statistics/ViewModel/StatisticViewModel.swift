//
//  StatisticViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 04/12/23.
//

import Foundation

class StatisticViewModel: ObservableObject {
    
    @Published var transactionModel = [TransactionModel]()
    
    private let getTransactionUseCase = GetTransactionUseCase()
    
    func getTransactions() {
        Task {
            let result = await getTransactionUseCase.execute(params: GetTransactionUseCase.Params())
            switch result {
            case .success(let transaction):
                DispatchQueue.main.sync {
                    self.transactionModel = transaction
                }
            case .failure(let error):
                print("Error fetching transaction: \(error)")
            }
        }
    }
}

extension StatisticViewModel {
    func totalRevenue(forMonth date: Date) -> Int {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        let transactionsInMonth = transactionModel.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
        return transactionsInMonth.reduce(0) { $0 + $1.totalTransaction }
    }
    
    func totalProfit(forMonth date: Date) -> Int {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        let transactionsInMonth = transactionModel.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
        return transactionsInMonth.reduce(0) { $0 + totalProfit(for: $1.items) }
    }
    
    private func totalProfit(for items: [ItemTransactionModel]) -> Int {
        return items.reduce(0) { $0 + $1.totalProfitPerITem }
    }
}
