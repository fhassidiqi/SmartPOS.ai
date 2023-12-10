//
//  RemoteDataSource.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseFirestoreSwift

class RemoteDataSource {
    
    static let shared = RemoteDataSource()
    private let db = Firestore.firestore()
    
    func fetchCategories() async throws -> [CategoryResponse] {
        let categoriesRefference = db.collection(CategoryResponse.collectionName)
        let snapshots = try await categoriesRefference.getDocuments()
        var categories = [CategoryResponse]()
        
        for document in snapshots.documents {
            if let name = document.data()["name"] as? String {
                let category = CategoryResponse(id: document.documentID, name: name)
                categories.append(category)
            }
        }
        return categories
    }
    
    func fetchCategory(reference: DocumentReference) async throws -> CategoryResponse {
        return try await reference.getDocument(as: CategoryResponse.self)
    }
    
    func fetchItems(categories: [String]? = nil) async throws -> [ItemResponse] {
        var filters = [Filter]()
        if let categories = categories {
            let categoryRefs = categories.map { category in
                db.collection(CategoryResponse.collectionName).document(category)
            }
            filters.append(Filter.whereField("category", in: categoryRefs))
        }
        
        let itemDocumentRefference = db.collection(ItemResponse.collectionName)
            .whereFilter(Filter.andFilter(filters))
        
        let snapshots = try await itemDocumentRefference.getDocuments()
        return try snapshots.documents.map { snapshots in
            try snapshots.data(as: ItemResponse.self)
        }
    }
    
    func fetchItem(reference: DocumentReference) async throws -> ItemResponse {
        return try await reference.getDocument(as: ItemResponse.self)
    }
    
    func transactionDocument(transactionId: String?) -> DocumentReference {
        let collectionName = db.collection("transactions")
        return collectionName.document(transactionId.orEmpty())
    }
    
    func fetchTransactions(items: [String]? = nil, sort: SortType = .date) async throws -> [TransactionResponse] {
        var filters = [Filter]()
        if let items = items {
            let itemRefs = items.map { item in
                db.collection(ItemResponse.collectionName).document(item)
            }
            filters.append(Filter.whereField("items", in: itemRefs))
        }
        
        var transactionDocReff = db.collection(TransactionResponse.collectionName)
            .whereFilter(Filter.andFilter(filters))
        
        if sort == .cashier {
            transactionDocReff = transactionDocReff.order(by: "Cashier", descending: true)
        } else if sort == .orderNumber {
            transactionDocReff = transactionDocReff.order(by: "Order Number", descending: true)
        }
        
        let snapshots = try await transactionDocReff.getDocuments()
        return try snapshots.documents.map { snapshots in
            try snapshots.data(as: TransactionResponse.self)
        }
    }
    
    func fetchTransaction(reference: DocumentReference) async throws -> TransactionResponse {
        return try await reference.getDocument(as: TransactionResponse.self)
    }
    
    func addTransaction(itemTransaction: [ItemTransactionModel], transaction: TransactionModel, transactionId: String?) async throws -> Bool {
        
        guard let transactionId = transactionId, !transactionId.isEmpty else {
            throw ErrorType.idNotFound
        }
        
        let items = itemTransaction.map { itemId in
            
            let itemRef = db.collection(ItemResponse.collectionName).document()
            
            return [
                "item": db.collection(ItemResponse.collectionName).document(itemId.item.id.orEmpty()),
                "quantity": itemId.quantity,
                "totalPricePerItem": itemId.item.price * itemId.quantity,
                "totalProfitPerItem": itemId.item.profit * itemId.quantity,
                "totalOmzetPerItem": itemId.item.omzet * itemId.quantity
            ]
        }
        
        try await transactionDocument(transactionId: transactionId)
            .setData([
                "cashier": transaction.cashier,
                "orderNumber": transaction.orderNumber,
                "date": transaction.date,
                "items": items,
                "tax": transaction.tax,
                "totalTransaction": transaction.totalTransaction,
                "totalTransactionBeforeTax": transaction.totalTransactionBeforeTax
            ], merge: true)
        
        return true
        
    }
    
    func deleteTransaction(transactionId: String) async throws -> Bool {
        try await db.collection(TransactionResponse.collectionName)
            .document(transactionId)
            .delete()
        
        return true
    }
}

enum ErrorType: Error {
    case invalidDate, invalidData, idNotFound
}
