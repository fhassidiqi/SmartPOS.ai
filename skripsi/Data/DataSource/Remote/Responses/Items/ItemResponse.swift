//
//  ItemResponse.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ItemResponse: Codable {
    static let collectionName = "items"
    
    @DocumentID var id: String?
    var name: String
    var category: DocumentReference
    var imageUrl: String
    var description: String
    var price: Int
    var omzet: Int
    var profit: Int
    var discount: Int?
}
