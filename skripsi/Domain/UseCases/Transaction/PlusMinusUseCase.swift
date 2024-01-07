//
//  PlusMinusUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 01/01/24.
//

import Foundation

class PlusMinusUseCase: BaseUseCase {
    
    typealias Params = PlusMinusUseCase.Param
    typealias Response = (Increment: [ItemTransactionModel], Decrement: [ItemTransactionModel])
    
    func execute(params: Param) async -> Result<(Increment: [ItemTransactionModel], Decrement: [ItemTransactionModel]), Error> {
        let incrementResult = incrementQuantity(for: params.item, itemTransactionModel: params.itemTransaction)
        let decrementResult = decrementQuantity(for: params.item, itemTransactionModel: params.itemTransaction)
        
        return .success((incrementResult, decrementResult))
    }
    
    private func incrementQuantity(for item: ItemModel, itemTransactionModel: [ItemTransactionModel]) -> [ItemTransactionModel] {
        return itemTransactionModel.map { itemTransaction -> ItemTransactionModel in
            if itemTransaction.item.id == item.id {
                var mutableItemTransaction = itemTransaction
                mutableItemTransaction.quantity += 1
                return mutableItemTransaction
            } else {
                return itemTransaction
            }
        }
    }
    
    private func decrementQuantity(for item: ItemModel, itemTransactionModel: [ItemTransactionModel]) -> [ItemTransactionModel] {
        return itemTransactionModel.map { itemTransaction -> ItemTransactionModel in
            if itemTransaction.item.id == item.id {
                var mutableItemTransaction = itemTransaction
                if mutableItemTransaction.quantity > 0 {
                    mutableItemTransaction.quantity -= 1
                }
                return mutableItemTransaction
            } else {
                return itemTransaction
            }
        }.filter { $0.quantity > 0 } // Filter out items with quantity <= 0
    }
    
    struct Param {
        let item: ItemModel
        let itemTransaction: [ItemTransactionModel]
        let quantity: Int
    }
}
