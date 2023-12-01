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
    private let addItemTransactionUseCase = AddItemTransactionUseCase()
    private let getItemTransactionUseCase = GetItemTransactionUseCase()
    
    func AddItemTransaction(transactionId: String, itemId: [String], orderNumber: String, quantity: Int, amount: Double, totalPrice: Double, cashier: String) {
        Task {
            DispatchQueue.main.sync {
                self.transactionLoading = true
            }
            
            let result = await addItemTransactionUseCase.execute(params: AddItemTransactionUseCase.Param(transactionId: transactionId, itemId: itemId, orderNumber: orderNumber, quantity: quantity, amount: amount, totalPrice: totalPrice, cashier: cashier))
            switch result {
            case .success:
                DispatchQueue.main.sync {
                    self.getItemTransaction(itemId: itemId)
                    self.transactionLoading = false
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.transactionLoading = false
                }
                break
            }
        }
    }
    
    func printItemTransaction() {
        
    }
    
    func getItemTransaction(itemId: [String]) {
        Task {
            DispatchQueue.main.sync {
                self.transactionLoading = true
            }
            
            let result = await getItemTransactionUseCase.execute(params: GetItemTransactionUseCase.Param(itemId: itemId))
            switch result {
            case .success(let itemTransaction):
                DispatchQueue.main.sync {
                    self.transactionModel = itemTransaction
                    self.transactionLoading = false
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.transactionLoading = false
                }
                break
            }
        }
    }
    
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
