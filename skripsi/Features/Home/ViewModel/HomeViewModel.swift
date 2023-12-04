//
//  HomeViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var itemLoading = false
    @Published var transactionModel = [TransactionModel]()
    @Published var currentSortingOption: SortType = .date
    
    private let getTransactionUseCase = GetTransactionUseCase()
    private let deleteItemTransactionUseCase = DeleteTransactionUseCase()
    
    var todayIncome: String {
        let today = Date() 
        let filteredTransactions = transactionModel.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
        let totalIncome = filteredTransactions.reduce(0) { $0 + $1.totalTransaction }
        let formattedIncome = NumberFormatter.localizedString(from: NSNumber(value: totalIncome), number: .currency)
        return formattedIncome
    }
    
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
    
    func deleteTransaction(transactionId: String) {
        Task {
            let result = await deleteItemTransactionUseCase.execute(params: DeleteTransactionUseCase.Param(transactionId: transactionId))
            switch result {
            case .success :
                DispatchQueue.main.sync {
                    self.getTransactions()
                    self.itemLoading = false
                }
                break
            case .failure(let error):
                print("Error \(error)")
                DispatchQueue.main.sync {
                    self.itemLoading = false
                }
                break
            }
        }
    }
    
    func sortTransactions(by sortingOption: SortType) {
        switch sortingOption {
        case .orderNumber:
            transactionModel.sort { $0.orderNumber < $1.orderNumber }
        case .cashier:
            transactionModel.sort { $0.cashier < $1.cashier }
        case .date:
            transactionModel.sort { $0.date < $1.date }
        }
        
        currentSortingOption = sortingOption
    }
}

enum SortType: String, CaseIterable, Identifiable {
    case cashier
    case orderNumber
    case date
    
    var id: Self { return self }  // Identifiable conformance
    
    var title: String {
        switch self {
        case .cashier: return "Cashier"
        case .orderNumber: return "Order Number"
        case .date: return "Date"
        }
    }
}
