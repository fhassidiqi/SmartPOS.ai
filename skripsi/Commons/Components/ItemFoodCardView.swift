//
//  ItemFoodCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemFoodCardView: View {
    
    var itemModel: ItemModel
    @StateObject private var vm = FoodListViewModel()
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(itemModel.name)
                    .font(.headline)
                
                Text(itemModel.description)
                    .font(.caption)
                
                if vm.quantity > 1 {
                    Text("\(itemModel.price * vm.quantity)")
                        .font(.caption)
                } else {
                    Text("\(itemModel.price)")
                        .font(.caption)
                }
                
                if vm.quantity == 0 {
                    Button {
                        vm.quantity += 1
                        print(vm.quantity)
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
                        Image(systemName: "minus.circle")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary100)
                            .onTapGesture {
                                // TODO: quantity berkurang
                                vm.quantity -= 1
                                print(vm.quantity)
                            }
                        
                        Text("\(vm.quantity)")
                            .font(.caption).bold()
                            .foregroundStyle(Color.text.black)
                            .padding(6)
                        
                        Image(systemName: "plus.circle")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary100)
                            .onTapGesture {
                                // TODO: quantity nambah
                                vm.quantity += 1
                                print(vm.quantity)
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
