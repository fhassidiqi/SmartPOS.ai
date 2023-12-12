//
//  ItemFoodCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemFoodCardView: View {
    
    var itemModel: ItemModel
    var itemTransactionModel: ItemTransactionModel
    @StateObject private var vm = FoodListViewModel()
    var onAddButtonTapped: (ItemTransactionModel) -> Void?
    
    private func createUpdatedItemTransaction(withQuantity quantity: Int) -> ItemTransactionModel {
        return ItemTransactionModel(
            item: itemTransactionModel.item,
            quantity: quantity,
            totalPricePerItem: itemModel.price * quantity,
            totalProfitPerItem: itemModel.profit * quantity,
            totalOmzetPerItem: itemModel.omzet * quantity
        )
    }
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(itemModel.name)
                    .font(.headline)
                
                Text(itemModel.description)
                    .font(.caption)
                
                if itemTransactionModel.quantity > 1 {
                    Text("\(itemTransactionModel.item.price * itemTransactionModel.quantity)")
                        .font(.caption)
                } else {
                    Text("\(itemTransactionModel.item.price)")
                        .font(.caption)
                }
                
                if itemTransactionModel.quantity == 0 {
                    Button {
                        vm.incrementQuantity(for: itemModel)

                        let updatedItemTransaction = createUpdatedItemTransaction(withQuantity: itemTransactionModel.quantity + 1)
                        onAddButtonTapped(updatedItemTransaction)
                        
                    } label: {
                        Text("Add")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary100)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.5)
                                    .strokeBorder(Color.primary100, lineWidth: 1)
                            )
                    }
                } else {
                    HStack {
                        Button {
                            vm.decrementQuantity(for: itemModel)
                            
                            let updatedItemTransaction = createUpdatedItemTransaction(withQuantity: itemTransactionModel.quantity - 1)
                            onAddButtonTapped(updatedItemTransaction)
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary100)
                        }
                        
                        Text("\(itemTransactionModel.quantity)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.text.black)
                            .padding(6)
                        
                        Button {
                            vm.incrementQuantity(for: itemModel)
                            
                            let updatedItemTransaction = createUpdatedItemTransaction(withQuantity: itemTransactionModel.quantity + 1)
                            onAddButtonTapped(updatedItemTransaction)
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary100)
                        }
                    }
                }
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: itemModel.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                case .empty:
                    ProgressView()
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
