//
//  ItemModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation

struct ItemModel: Identifiable, Hashable {
    let id: String?
    let name: String
    let imageUrl: String
    let description: String
    let category: String
    let omzet: Int
    let profit: Int
    let price: Int
}
