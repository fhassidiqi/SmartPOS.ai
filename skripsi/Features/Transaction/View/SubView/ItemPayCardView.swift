//
//  ItemPayCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemPayCardView: View {
    
    var itemModel: ItemModel
    var itemTransactionModel: ItemTransactionModel
    @Binding var selectedItems: [ItemTransactionModel]
    @StateObject private var vm = FoodListViewModel()
    var updateSelectedItem: (ItemTransactionModel) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(itemModel.name)
                    .font(.headline)
                
                Text("Rp. \(itemModel.price)")
                    .font(.footnote)
                
                HStack(spacing: 16) {
                    Button(action: {
                        updateSelectedItem(vm.decrementQuantity(for: itemModel))
                    }, label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                    
                    Text("1")
                        .font(.headline)
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                }
                .padding(.top, 10)
            }
            
            Spacer()
            
            Image("makan2")
            
        }
    }
}

//#Preview {
//    ItemPayCardView()
//}
