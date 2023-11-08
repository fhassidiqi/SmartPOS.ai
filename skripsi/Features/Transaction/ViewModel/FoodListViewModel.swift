//
//  FoodListViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 25/10/23.
//

import Foundation
import SwiftUI

class FoodListViewModel: ObservableObject {
    
    @Published var categoriesModel = [CategoryModel]()
    @Published var itemsModel = [ItemModel]()
    
    private let getCategoriesUseCase = GetCategoriesUseCase()
    private let getItemUseCase = GetItemsUseCase()
    
    func getCategories() {
        Task {
            do {
                let result = await getCategoriesUseCase.execute(params: GetCategoriesUseCase.Param())
                switch result {
                case .success(let categories):
                    print("Fetched categories:", categories)
                    DispatchQueue.main.sync {
                        self.categoriesModel = categories
                    }
                case .failure(let error):
                    print("Error fetching categories: \(error.localizedDescription)")
                }
            } catch {
                print("An error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func getItems(categoryIDs: [String] = []) {
        Task {
            var categories: [String]? = nil
            if !categoryIDs.isEmpty {
                categories = categoryIDs
            }
            
            let result = await getItemUseCase.execute(params: GetItemsUseCase.Param(categories: categories))
            switch result {
            case .success(let items):
                print("Fetched items:", items)
                DispatchQueue.main.sync {
                    self.itemsModel = items
                }
            case .failure(let error):
                print("Error fetching items: \(error.localizedDescription)")
            }
            
        }
    }
}
