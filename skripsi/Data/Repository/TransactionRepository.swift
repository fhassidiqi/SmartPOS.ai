//
//  TransactionRepository.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 10/11/23.
//

import Foundation

protocol ITransactionRepository {
    func getTransactions(items: [String]?) async throws -> [TransactionModel]
    func getTransaction(id: String) async throws -> TransactionModel?
}

class TransactionRepository: ITransactionRepository {
    
    private let remoteDataSource = RemoteDataSource.shared
    static let shared = TransactionRepository()
    
    func getTransactions(items: [String]?) async throws -> [TransactionModel] {
        do {
            let response = try await remoteDataSource.fetchTransactions(items: items)
            
            var transactions = [TransactionModel]()
            
            for transactionData in response {
                transactions.append(
                    TransactionModel(
                        id: transactionData.id.orEmpty(),
                        orderNumber: transactionData.orderNumber,
                        date: transactionData.date,
                        item: transactionData.item.map {
                            ItemModel(id: $0.id.orEmpty(), name: $0.name, imageUrl: $0.imageUrl, description: $0.description, category: $0.category.documentID, omzet: $0.omzet, profit: $0.profit, price: $0.price, quantity: $0.quantity, totalPrice: $0.totalPrice, discount: $0.discount)
                        },
                        amount: transactionData.amount,
                        cashier: transactionData.cashier
                    )
                )
            }
            return transactions
        } catch {
            print("Error get Transaction: \(error)")
            throw error
        }
    }
    
    func getTransaction(id: String) async throws -> TransactionModel? {
        return nil
    }
}
