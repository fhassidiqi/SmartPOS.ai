//
//  GetItemTransactionUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/11/23.
//

import Foundation

class GetItemTransactionUseCase: BaseUseCase {
    
    private let repository = TransactionRepository.shared
    
    typealias Params = Param
    typealias Response = [TransactionModel]
    
    func execute(params: Param) async -> Result<[TransactionModel], Error> {
        do {
            let result = try await repository.getTransactions(items: params.itemId, sort: params.sort)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param {
        var itemId: [String]
        var sort: SortType = .date
    }
}
