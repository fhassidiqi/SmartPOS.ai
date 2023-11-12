//
//  TransactionModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionModel: Identifiable, Hashable {
    let id: String?
    let orderNumber: String
    let date: Date
    let item: [ItemModel]
    var quantity: Int
    let totalPrice: Int
    let amount: Int
    let cashier: String
    
}
