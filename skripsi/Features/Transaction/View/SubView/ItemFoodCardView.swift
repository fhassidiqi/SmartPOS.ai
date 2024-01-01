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
                        Task {
                            vm.incrementQuantity(for: itemModel)
                            onAddButtonTapped(vm.createUpdatedItemTransaction(for: itemModel, withQuantity: itemTransactionModel.quantity + 1))
                        }
                        
                    } label: {
                        Text("Add")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primaryColor100)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 0.5)
                                    .strokeBorder(Color.primaryColor100, lineWidth: 1)
                            )
                    }
                } else {
                    HStack {
                        Button {
                            Task {
                                vm.decrementQuantity(for: itemModel)
                                onAddButtonTapped(vm.createUpdatedItemTransaction(for: itemModel, withQuantity: itemTransactionModel.quantity - 1))
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryColor100)
                        }
                        
                        Text("\(itemTransactionModel.quantity)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.text.primary100)
                            .padding(6)
                        
                        Button {
                            Task {
                                vm.incrementQuantity(for: itemModel)
                                onAddButtonTapped(vm.createUpdatedItemTransaction(for: itemModel, withQuantity: itemTransactionModel.quantity + 1))
                            }
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primaryColor100)
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
