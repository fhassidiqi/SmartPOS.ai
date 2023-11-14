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
    
    func getTransactionItem(itemId: String) async throws -> TransactionModel {
        if let response = try await remoteDataSource.getItemTransaction(itemID: itemId) {
            for transaction in response.item {
                let itemResponse = try await remoteDataSource.fetchItem(reference: transaction)
            }
            
            
        }
    }
    
//    func getUserBooks(bookID: String, userID: String) async throws -> UsersBooksModel? {
//        if let response = try await remoteDataSource.getUserBook(bookID: bookID, userID: userID) {
//            let bookResponse = try await remoteDataSource.fetchBook(reference: response.book)
//            let categoryResponse = try await remoteDataSource.fetchCategory(reference: bookResponse.category)
//            let user = try await remoteDataSource.getUser(userId: response.user.documentID)
//            let contents = bookResponse.contents.map {
//                ContentModel(chapter: $0.chapter, text: $0.text, title: $0.title)
//            }
//            
//            let book = BookModel(id: bookResponse.id.orEmpty(), title: bookResponse.title, author: bookResponse.author, category: categoryResponse.name, categoryImageURL: categoryResponse.imageURL, description: bookResponse.description, released: bookResponse.released.dateValue(), imageURL: categoryResponse.imageURL, contents: contents, reviews: [])
//            
//            return UsersBooksModel(id: response.id.orEmpty(), book: book, lastPage: response.lastPage, status: response.status, user: user, lastRead: response.lastRead.dateValue())
//        } else {
//            return nil
//        }
//    }
}
