//
//  ItemFoodCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemFoodCardView: View {
    
    var itemModel: ItemModel
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(itemModel.name)
                    .font(.headline)
                
                Text(itemModel.description)
                    .font(.caption)
                
                Text("\(itemModel.price)")
                    .font(.caption)
                
                Button(action: {
                    
                }, label: {
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
                })
            }
            
            Spacer()
            
            AsyncImage(url: URL(string: itemModel.imageUrl))
        }
    }
}

#Preview {
    ItemFoodCardView(itemModel: ItemModel(id: "1", name: "Name", imageUrl: "imageUrl", description: "Description", category: "Category", omzet: 120000, profit: 10000, price: 130000))
}
