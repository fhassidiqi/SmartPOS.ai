//
//  ItemFoodCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemFoodCardView: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Bottegea’s Fried Rice")
                    .font(.headline)
                
                Text("Orange leaves, chicken, tempeh, sambal, singkong, egg, crackers.")
                    .font(.caption)
                
                Text("Rp. 129.000")
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
            
            Image("makan2")
        }
    }
}

#Preview {
    ItemFoodCardView()
}
