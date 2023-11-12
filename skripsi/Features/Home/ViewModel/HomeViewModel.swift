//
//  HomeViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import Foundation

class HomeViewModel: ObservableObject {
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
