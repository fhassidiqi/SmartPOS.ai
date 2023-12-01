//
//  TransactionModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation

struct TransactionModel: Identifiable, Hashable {
    let id: String?
    let orderNumber: String
    let date: Date
    let item: [ItemModel]
    var subTotal: Int
    let totalPrice: Int
    let tax: Int
    let cashier: String
    let totalPriceBeforeTax: Int
}
