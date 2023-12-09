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
    @Published var itemTransactionModel = [ItemTransactionModel]()
    @Published var quantity: Int = 0
    @Published var transactionLoading = false
    @Published var selectedItems = [ItemTransactionModel]()
    
    private let getCategoriesUseCase = GetCategoriesUseCase()
    private let getItemUseCase = GetItemsUseCase()
    private let addTransactionUseCase = AddTransactionUseCase()
    
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
    
    func addTransaction(transactionId: String? = nil, date: Date) {
        Task {
            let orderNumber = generateOrderNumber(date: date)
            let tax = Int(Double(selectedItems.reduce(0) { $0 + $1.totalPricePerItem }) * 0.1)
            let totalTransaction = selectedItems.reduce(0) { $0 + $1.totalPricePerItem } + tax
            
            let transaction = TransactionModel(
                id: transactionId.orEmpty(),
                orderNumber: orderNumber,
                date: date,
                items: selectedItems,
                cashier: "Falah Hasbi Assidiqi", // Default untuk sementara
                totalTransactionBeforeTax: selectedItems.reduce(0) { $0 + $1.totalPricePerItem },
                tax: tax,
                totalTransaction: totalTransaction
            )
            
            let result = await addTransactionUseCase.execute(params: AddTransactionUseCase.Param(items: transaction.items, transaction: transaction))
            switch result {
            case .success(let success):
                print("Success: \(success)")
            case .failure(let error):
                print("Error adding transaction: \(error.localizedDescription)")
            }
        }
    }
    
    private func generateOrderNumber(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        let dateString = dateFormatter.string(from: date)
        
        let transactionSequence = String(transactionModel.count + 1)
        
        let orderNumber = "\(dateString)\(transactionSequence)"
        
        return orderNumber
    }
    
    func itemTransactionModel(for item: ItemModel) -> ItemTransactionModel? {
        return itemTransactionModel.first { $0.item.id == item.id }
    }
    
    func incrementQuantity(for item: ItemModel) {
        if let index = itemTransactionModel.enumerated().first(where: { $0.element.item.id == item.id })?.offset {
            itemTransactionModel[index].quantity += 1
        }
    }
    
    func decrementQuantity(for item: ItemModel) {
        if let index = itemTransactionModel.enumerated().first(where: { $0.element.item.id == item.id && $0.element.quantity > 0 })?.offset {
            itemTransactionModel[index].quantity -= 1
        }
    }
}
