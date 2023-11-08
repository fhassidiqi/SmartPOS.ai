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
            print("Categories: \(categories)")
        }
        
        let itemDocumentRefference = db.collection(ItemResponse.collectionName)
            .whereFilter(Filter.andFilter(filters))
        
        let snapshots = try await itemDocumentRefference.getDocuments()
        return try snapshots.documents.map { snapshots in
            try snapshots.data(as: ItemResponse.self)
        }
    }
    
    func fetchItem(refference: DocumentReference) async throws -> ItemResponse {
        return try await refference.getDocument(as: ItemResponse.self)
    }
    
    func transactionDocument(transactionId: String) -> DocumentReference {
        let collectionName = db.collection("transaction")
        return collectionName.document(transactionId)
    }
    
    // TODO: Create add transaction and edit
    func createNewTransaction(transaction: TransactionModel) async throws {
        let transactionRefference = try await transactionDocument(transactionId: transaction.id.orEmpty())
            .getDocument()
        
        if !transactionRefference.exists {
            try await transactionDocument(transactionId: transaction.id.orEmpty())
                .setData([
                    "id" : transaction.id.orEmpty(),
                    "orderNumber" : transaction.orderNumber.orEmpty(),
                    "date" : transaction.date ?? Date.now,
                    "item" : transaction.item,
                    "quantity" : transaction.quantity,
                    "amount" : transaction.amount,
                    "cashier" : transaction.cashier.orEmpty()
                ], merge: true)
        }
    }
    
    func getTransaction(transactionId: String) async throws -> TransactionModel {
        try await transactionDocument(transactionId: transactionId).getDocument(as: TransactionModel.self)
    }
    
    
}
