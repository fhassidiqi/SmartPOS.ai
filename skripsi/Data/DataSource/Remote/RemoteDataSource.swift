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
    
    func transactionDocument(transactionId: String) -> DocumentReference {
        let collectionName = db.collection("transaction")
        return collectionName.document(transactionId)
    }
    
    func fetchTransactions(items: [String]? = nil) async throws -> [TransactionResponse] {
        var filters = [Filter]()
        if let items = items {
            let itemRefs = items.map { item in
                db.collection(ItemResponse.collectionName).document(item)
            }
            filters.append(Filter.whereField("item", in: itemRefs))
        }
        
        let transactionDocReff = db.collection(TransactionResponse.collectionName)
            .whereFilter(Filter.andFilter(filters))
        
        let snapshots = try await transactionDocReff.getDocuments()
        return try snapshots.documents.map { snapshots in
            try snapshots.data(as: TransactionResponse.self)
        }
    }
    
    func fetchTransaction(reference: DocumentReference) async throws -> TransactionResponse {
        return try await reference.getDocument(as: TransactionResponse.self)
    }
    // TODO: Create add transaction and edit
    
    func getItemTransaction(itemID: String) async throws -> TransactionResponse? {
        let itemReference = db.collection(ItemResponse.collectionName).document(itemID)
        let itemTransactionReference = db.collection(TransactionResponse.collectionName)
            .whereField("item", isEqualTo: itemReference)
        let snapshot = try await itemTransactionReference.getDocuments()
        if snapshot.documents.count > 0 {
            return try snapshot.documents[0].data(as: TransactionResponse.self)
        } else {
            return nil
        }
    }
    
    func addItemTransaction(transactionId: String, itemIds: [String], orderNumber: String, quantity: Int, amount: Double, totalPrice: Double, cashier: String) async throws -> Bool {
        let newTransactionRef = db.collection(TransactionResponse.collectionName).document()
        
        for itemId in itemIds {
            let item = db.collection(ItemResponse.collectionName).document(itemId)
            let newTransactionReference = db.collection(TransactionResponse.collectionName).document()
            let transactionDocument = try await db.collection(TransactionResponse.collectionName)
                .whereField("item", isEqualTo: item)
                .getDocuments()
            
            if transactionDocument.isEmpty {
                try await newTransactionReference
                    .setData([
                        "orderNumber": orderNumber,
                        "item": [item],
                        "quantity": quantity,
                        "date": Timestamp(),
                        "amount": amount,
                        "totalPrice": totalPrice,
                        "cashier": cashier,
                    ], merge: true)
            } else {
                return false
            }
        }
        return true
    }
}
