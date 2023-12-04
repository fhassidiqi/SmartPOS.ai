//
//  GetTransactionUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 10/11/23.
//

import Foundation

class GetTransactionUseCase: BaseUseCase {
    
    private let repository = TransactionRepository.shared
    typealias Params = GetTransactionUseCase.Param
    typealias Response = [TransactionModel]
    
    func execute(params: Params) async -> Result<[TransactionModel], Error> {
        do {
            let result = try await repository.getTransactions(items: params.items, sort: params.sort)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param {
        var items: [String]? = nil
        var sort: SortType = .date
    }
}
