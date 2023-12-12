//
//  ItemPayCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemPayCardView: View {
    
    var selectedItems: ItemTransactionModel
    @ObservedObject private var vm = FoodListViewModel()
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(selectedItems.item.name)
                    .font(.headline)
                
                Text("Rp. \(selectedItems.item.price)")
                    .font(.footnote)
                
                HStack(spacing: 16) {
                    Button(action: {
                        vm.decrementQuantity(for: selectedItems.item)
                    }, label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                    
                    Text("\(selectedItems.quantity)")
                        .font(.headline)
                    
                    Button(action: {
                        vm.incrementQuantity(for: selectedItems.item)
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                }
                .padding(.top, 10)
                
                
                Spacer()
                
                AsyncImage(url: URL(string: selectedItems.item.imageUrl)) { phase in
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
}
