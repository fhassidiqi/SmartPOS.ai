//
//  DeleteItemTransactionUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/11/23.
//

import Foundation

class DeleteItemTransactionUseCase: BaseUseCase {
    typealias Params = Param
    typealias Response = Bool
    
    private let repository = TransactionRepository.shared
    
    func execute(params: Param) async -> Result<Bool, Error> {
        do {
            let result = try await repository.deleteItemTransaction(transactionId: params.transactionId)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param { let transactionId: String }
}
