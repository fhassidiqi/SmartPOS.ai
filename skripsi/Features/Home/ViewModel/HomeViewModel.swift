//
//  HomeViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var transactionModel = [TransactionModel]()
    @Published var itemLoading = false
    
    private let getTransactionUseCase = GetTransactionUseCase()
    private let deleteItemTransactionUseCase = DeleteItemTransactionUseCase()
    
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
            let result = await deleteItemTransactionUseCase.execute(params: DeleteItemTransactionUseCase.Param(transactionId: transactionId))
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
}

enum TransactionSorting: String, CaseIterable, Identifiable {
    case orderName
    case cashier
    case date
    var id: Self { return self }
    
    var cashier: String {
        switch self {
        case .orderName:
            return "Order Name"
        case .cashier:
            return "Cashier"
        case .date:
            return "Date"
        }
    }
}
