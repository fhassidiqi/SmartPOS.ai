//
//  ItemRepository.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 23/10/23.
//

import Foundation

protocol IItemRepository {
    func getItems(categories: [String]?) async throws -> [ItemModel]
    func getItem(id: String) async throws -> ItemModel?
}

class ItemRepository: IItemRepository {
    
    private let remoteDataSource = RemoteDataSource.shared
    static let shared = ItemRepository()
    
    func getItems(categories: [String]?) async throws -> [ItemModel] {
        do {
            let response = try await remoteDataSource.fetchItems(categories: categories)
            
            var items = [ItemModel]()
            
            for itemData in response {
                let category = try await remoteDataSource.fetchCategory(reference: itemData.category)
                
                items.append(ItemModel(id: itemData.id.orEmpty(), name: itemData.name, imageUrl: itemData.imageUrl, description: itemData.description, category: category.name, omzet: itemData.omzet, profit: itemData.profit, price: itemData.price, discount: itemData.discount, quantity: itemData.quantity, totalOmzetPerItem: itemData.totalOmzetPerItem, totalPricePerItem: itemData.totalPricePerItem, totalProfitPerItem: itemData.totalProfitPerItem))
            }
            return items
        } catch {
            print("Error in getItems: \(error)")
            throw error
        }
    }
    
    func getItem(id: String) async throws -> ItemModel? {
        return nil
    }
    
    
}
