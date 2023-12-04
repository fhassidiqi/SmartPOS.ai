//
//  TransactionResponse.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 10/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionResponse: Codable {
    static let collectionName = "transactions"
    
    @DocumentID var id: String?
    var orderNumber: String
    var date: Timestamp
    var items: [ItemTransactionResponse]
    var cashier: String
    var tax: Int
    var totalTransactionBeforeTax: Int
    var totalTransaction: Int
}

struct ItemTransactionResponse: Codable {
    var item: DocumentReference
    var quantity: Int
    var totalPricePerItem: Int
    var totalProfitPerItem: Int
    var totalOmzetPerItem: Int
}
