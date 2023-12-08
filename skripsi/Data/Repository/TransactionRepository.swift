//
//  TransactionRepository.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 10/11/23.
//

import Foundation
import Combine

protocol ITransactionRepository {
    func getTransactions(items: [String]?, sort: SortType) async throws -> [TransactionModel]
    func getTransaction(id: String) async throws -> TransactionModel?
}

class TransactionRepository: ITransactionRepository {
    
    private let remoteDataSource = RemoteDataSource.shared
    static let shared = TransactionRepository()
    
    func getTransactions(items: [String]?, sort: SortType) async throws -> [TransactionModel] {
        
        let response = try await remoteDataSource.fetchTransactions(items: items, sort: sort)
        
        var transactions = [TransactionModel]()
        for transaction in response {
            
            var itemTransactions = [ItemTransactionModel]()
            for itemTransaction in transaction.items {
                let category = try await remoteDataSource.fetchCategory(reference: itemTransaction.item)
                let itemResponse = try await remoteDataSource.fetchItem(reference: itemTransaction.item)
                
                let item = ItemModel(id: itemResponse.id.orEmpty(), name: itemResponse.name, imageUrl: itemResponse.imageUrl, description: itemResponse.description, category: category.name, omzet: itemResponse.omzet, profit: itemResponse.profit, price: itemResponse.price, discount: itemResponse.discount)
                
                itemTransactions.append(ItemTransactionModel(item: item, quantity: itemTransaction.quantity, totalPricePerItem: itemTransaction.totalPricePerItem, totalProfitPerItem: itemTransaction.totalProfitPerItem, totalOmzetPerItem: itemTransaction.totalOmzetPerItem))
            }
            
            transactions.append(TransactionModel(id: transaction.id.orEmpty(), orderNumber: transaction.orderNumber, date: transaction.date.dateValue(), items: itemTransactions, cashier: transaction.cashier, totalTransactionBeforeTax: transaction.totalTransactionBeforeTax, tax: transaction.tax, totalTransaction: transaction.totalTransaction))
        }
        
        return transactions
    }
    
    func deleteTransaction(transactionId: String) async throws -> Bool {
        let result = try await remoteDataSource.deleteTransaction(transactionId: transactionId)
        
        return result
    }
    
    func getTransaction(id: String) async throws -> TransactionModel? {
        return nil
    }
}
