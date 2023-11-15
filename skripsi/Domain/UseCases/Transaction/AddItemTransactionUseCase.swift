//
//  AddItemTransactionUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/11/23.
//

import Foundation

class AddItemTransactionUseCase: BaseUseCase {
    typealias Params = Param
    typealias Response = Bool
    
    private let repository = TransactionRepository()
    
    func execute(params: Param) async -> Result<Bool, Error> {
        do {
            let result = try await repository.addItemTransaction(transactionId: params.transactionId, itemId: params.itemId, orderNumber: params.orderNumber, quantity: params.quantity, amount: params.amount, totalPrice: params.totalPrice, cashier: params.cashier)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    struct Param {
        let transactionId: String
        let itemId: [String]
        let orderNumber: String
        let quantity: Int
        let amount: Double
        let totalPrice: Double
        let cashier: String
    }
}
