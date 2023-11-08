//
//  TransactionModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TransactionModel: Codable, Hashable {
    let id: String?
    let orderNumber: String?
    let date: Date?
    let item: [DocumentReference]
    let quantity: Int
    let amount: Int
    let cashier: String?
}
