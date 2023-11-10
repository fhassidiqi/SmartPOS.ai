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
    static let collectionName = "transaction"
    
    @DocumentID var id: String?
    var orderNumber: String
    var date: Date
    var item: [ItemResponse]
    var amount: Int
    var cashier: String
}
