//
//  FoodListViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 25/10/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    
    func addTransaction(date: Date) {
        Task {
            let transactionId = Firestore.firestore().collection("transactions").document().documentID
            let orderNumber = generateOrderNumber(date: date)
            let tax = Int(Double(selectedItems.reduce(0) { $0 + $1.totalPricePerItem }) * 0.1)
            let totalTransaction = selectedItems.reduce(0) { $0 + $1.totalPricePerItem } + tax
            let items = selectedItems.map { ItemTransactionModel(item: $0.item, quantity: $0.quantity, totalPricePerItem: $0.item.price * $0.quantity, totalProfitPerItem: $0.item.profit * $0.quantity, totalOmzetPerItem: $0.item.omzet * $0.quantity) }
            
            let transaction = TransactionModel(
                id: transactionId,
                orderNumber: orderNumber,
                date: date,
                items: items,
                cashier: "Falah Hasbi Assidiqi", // Default untuk sementara
                totalTransactionBeforeTax: selectedItems.reduce(0) { $0 + $1.totalPricePerItem },
                tax: tax,
                totalTransaction: totalTransaction
            )
            
            print("Transaction: \(transaction)")
            
            let result = await addTransactionUseCase.execute(params: AddTransactionUseCase.Param(transactionId: transactionId, items: transaction.items, transaction: transaction))
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
        itemTransactionModel = itemTransactionModel.map { itemTransaction -> ItemTransactionModel in
            if itemTransaction.item.id == item.id {
                var mutableItemTransaction = itemTransaction
                mutableItemTransaction.quantity += 1
                return mutableItemTransaction
            } else {
                return itemTransaction
            }
        }
    }
    
    func decrementQuantity(for item: ItemModel) {
        itemTransactionModel = itemTransactionModel.map { itemTransaction -> ItemTransactionModel in
            if itemTransaction.item.id == item.id {
                var mutableItemTransaction = itemTransaction
                if mutableItemTransaction.quantity > 0 {
                    mutableItemTransaction.quantity -= 1
                }
                if mutableItemTransaction.quantity <= 0 {
                    return itemTransaction
                } else {
                    return mutableItemTransaction
                }
            } else {
                return itemTransaction
            }
        }.compactMap { $0 }
    }

    
}
