//
//  DeleteItemTransactionUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/11/23.
//

import Foundation

class DeleteTransactionUseCase: BaseUseCase {
    
    typealias Params = Param
    typealias Response = Bool
    
    private let repository = TransactionRepository.shared
    
    func execute(params: Params) async -> Result<Bool, Error> {
        do {
            let result = try await repository.deleteTransaction(transactionId: params.transactionId)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param { let transactionId: String }
}
