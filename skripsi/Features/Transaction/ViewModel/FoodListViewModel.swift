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
    @Published var transactionModel = [TransactionModel]()
    @Published var quantity: Int = 0
    @Published var transactionLoading = false
    
    private let getCategoriesUseCase = GetCategoriesUseCase()
    private let getItemUseCase = GetItemsUseCase()
    
    func getCategories() {
        Task {
            let result = await getCategoriesUseCase.execute(params: GetCategoriesUseCase.Param())
            switch result {
            case .success(let categories):
                DispatchQueue.main.sync {
                    self.categoriesModel = categories
                }
            case .failure(let error):
                print("Error fetching categories: \(error.localizedDescription)")
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
                DispatchQueue.main.sync {
                    self.itemsModel = items
                }
            case .failure(let error):
                print("Error fetching items: \(error.localizedDescription)")
            }   
        }
    }
}
