//
//  FoodListViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 25/10/23.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class FoodListViewModel: ObservableObject {
    
    @Published var isFlashOn = false
    @Published var payment: String = ""
    @Published var showAlertError = false
    @Published var willCapturePhoto = false
    
    @Published var itemsModel = [ItemModel]()
    @Published var categoriesModel = [CategoryModel]()
    @Published var transactionModel = [TransactionModel]()
    @Published var selectedItems = [ItemTransactionModel]()
    @Published var itemTransactionModel = [ItemTransactionModel]()
    
    private let getItemUseCase = GetItemsUseCase()
    private let getCategoriesUseCase = GetCategoriesUseCase()
    private let addTransactionUseCase = AddTransactionUseCase()
    
    private var subscriptions = Set<AnyCancellable>()
    
    func getCategories() {
        Task {
            let result = await getCategoriesUseCase.execute(params: GetCategoriesUseCase.Param())
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.categoriesModel = categories
                case .failure(let error):
                    print("Error fetching categories: \(error.localizedDescription)")
                }
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
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.itemsModel = items
                case .failure(let error):
                    print("Error fetching items: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updatePayment(withLabelName labelName: String) {
        self.payment = labelName
    }
    
    func addTransaction(date: Date) {
        Task {
            let transactionId = Firestore.firestore().collection("transactions").document().documentID
            let orderNumber = generateOrderNumber(date: date)
            let tax = Int(Double(selectedItems.reduce(0) { $0 + $1.totalPricePerItem }) * 0.1)
            let totalTransaction = selectedItems.reduce(0) { $0 + $1.totalPricePerItem } + tax
            let items = selectedItems.map {
                ItemTransactionModel(
                    item: $0.item,
                    quantity: $0.quantity,
                    totalPricePerItem: $0.item.price * $0.quantity,
                    totalProfitPerItem: $0.item.profit * $0.quantity,
                    totalOmzetPerItem: $0.item.omzet * $0.quantity
                )
            }
            
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
            
            self.selectedItems = []
            
            let result = await addTransactionUseCase.execute(params: AddTransactionUseCase.Param(transactionId: transactionId, items: transaction.items, transaction: transaction))
            switch result {
            case .success(let success):
                print("Success: \(success)")
            case .failure(let error):
                print("Error adding transaction: \(error.localizedDescription)")
            }
        }
    }
    
    func createUpdatedItemTransaction(for item: ItemModel, withQuantity quantity: Int) -> ItemTransactionModel {
        return ItemTransactionModel(
            item: item,
            quantity: quantity,
            totalPricePerItem: item.price * quantity,
            totalProfitPerItem: item.profit * quantity,
            totalOmzetPerItem: item.omzet * quantity
        )
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
    
    func calculateTotalPrice() -> Int {
        return selectedItems.reduce(0) { $0 + $1.totalPricePerItem }
    }
    
    func calculateTax() -> Int {
        return Int(Double(calculateTotalPrice()) * 0.1)
    }
    
    func calculateTotalWithTax() -> Int {
        return Int(Double(calculateTotalPrice()) * 1.1)
    }
    
    func calculateChange(enteredAmount: Double) -> Int {
        let totalPrice = Double(calculateTotalWithTax())
        return Int(enteredAmount - totalPrice)
    }
    
    private func generateOrderNumber(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyHHmm"
        let dateString = dateFormatter.string(from: date)
        
        let orderNumber = "\(dateString)"
        
        return orderNumber
    }
    
}
