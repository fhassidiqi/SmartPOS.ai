//
//  AddTransactionUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 09/12/23.
//

import Foundation

class AddTransactionUseCase: BaseUseCase {
    
    private let repository = TransactionRepository.shared
    typealias Params = AddTransactionUseCase.Param
    typealias Response = Bool
    
    func execute(params: Param) async -> Result<Bool, Error> {
        do {
            let result = try await repository.addTransaction(itemTransaction: params.items, transaction: params.transaction)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param {
        let items: [ItemTransactionModel]
        let transaction: TransactionModel
    }
}
