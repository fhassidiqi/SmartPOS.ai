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
    let items: [ItemTransactionModel]
    let cashier: String
    let totalTransactionBeforeTax: Int
    let tax: Int
    let totalTransaction: Int
}

struct ItemTransactionModel: Hashable {
    let item: ItemModel
    var quantity: Int
    let totalPricePerItem: Int
    let totalProfitPerItem: Int
    let totalOmzetPerItem: Int
}
