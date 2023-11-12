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
                
                var items = [ItemModel]()
                for itemResponse in transactionData.item {
                    do {
                        let itemResponse = try await remoteDataSource.fetchItem(reference: itemResponse)
                        let category = try await remoteDataSource.fetchCategory(reference: itemResponse.category)

                        let itemModel = ItemModel(
                            id: itemResponse.id.orEmpty(),
                            name: itemResponse.name,
                            imageUrl: itemResponse.imageUrl,
                            description: itemResponse.description,
                            category: category.name,
                            omzet: itemResponse.omzet,
                            profit: itemResponse.profit,
                            price: itemResponse.price,
                            discount: itemResponse.discount
                        )
                        items.append(itemModel)
                    } catch {
                        print("Error fetching item for reference: \(itemResponse.path), \(error)")
                    }
                }
                
                transactions.append(
                    TransactionModel(
                        id: transactionData.id.orEmpty(),
                        orderNumber: transactionData.orderNumber,
                        date: transactionData.date.dateValue(),
                        item: items,
                        quantity: transactionData.quantity,
                        totalPrice: transactionData.totalPrice,
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
