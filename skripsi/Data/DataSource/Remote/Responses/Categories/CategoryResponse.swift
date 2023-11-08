//
//  CategoryResponse.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 25/10/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CategoryResponse: Codable {
    static let collectionName = "categories"
    
    @DocumentID var id: String?
    var name: String
}
