//
//  TransactionRepository.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 10/11/23.
//

import Foundation

protocol ITransactionRepository {
    func getTransactions(items: [String]?, sort: SortType) async throws -> [TransactionModel]
    func getTransaction(id: String) async throws -> TransactionModel?
}

class TransactionRepository: ITransactionRepository {
    
    private let remoteDataSource = RemoteDataSource.shared
    static let shared = TransactionRepository()
    
    func getItemTransaction(itemId: String) async throws -> TransactionModel? {
        if let response = try await remoteDataSource.getItemTransaction(itemID: itemId) {
            var items = [ItemModel]()
            for item in response.item {
                let itemResponse = try await remoteDataSource.fetchItem(reference: item.self)
                let category = try await remoteDataSource.fetchCategory(reference: itemResponse.category)
                let item = ItemModel(id: itemResponse.id.orEmpty(), name: itemResponse.name, imageUrl: itemResponse.imageUrl, description: itemResponse.description, category: category.name, omzet: itemResponse.omzet, profit: itemResponse.profit, price: itemResponse.price, discount: itemResponse.discount, quantity: itemResponse.quantity, totalOmzetPerItem: itemResponse.totalOmzetPerItem, totalPricePerItem: itemResponse.totalPricePerItem, totalProfitPerItem: itemResponse.totalProfitPerItem)
            }
            return TransactionModel(id: response.id, orderNumber: response.orderNumber, date: response.date.dateValue(), item: items, subTotal: response.subTotal, totalPrice: response.totalPrice, tax: response.tax, cashier: response.cashier, totalPriceBeforeTax: response.totalPriceBeforeTax)
        } else {
            return nil
        }
    }
    
    func addItemTransaction(transactionId: String, itemId: [String], orderNumber: String, subTotal: Int, tax: Double, totalPrice: Double, cashier: String) async throws -> Bool {
        
        let results = try await remoteDataSource.addItemTransaction(transactionId: transactionId, itemIds: itemId, orderNumber: orderNumber, tax: tax, subTotal: subTotal, totalPrice: totalPrice, cashier: cashier)
        
        return results
    }
    
    func deleteItemTransaction(transactionId: String) async throws -> Bool {
        let result = try await remoteDataSource.deleteItemTransaction(transactionId: transactionId)
        
        return result
    }
    
    func getTransactions(items: [String]?, sort: SortType) async throws -> [TransactionModel] {
        do {
            let response = try await remoteDataSource.fetchTransactions(items: items, sort: sort)
            
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
                            discount: itemResponse.discount,
                            quantity: itemResponse.quantity,
                            totalOmzetPerItem: itemResponse.totalOmzetPerItem,
                            totalPricePerItem: itemResponse.totalPricePerItem,
                            totalProfitPerItem: itemResponse.totalProfitPerItem
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
                        subTotal: transactionData.subTotal,
                        totalPrice: transactionData.totalPrice,
                        tax: transactionData.tax,
                        cashier: transactionData.cashier,
                        totalPriceBeforeTax: transactionData.totalPriceBeforeTax
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
