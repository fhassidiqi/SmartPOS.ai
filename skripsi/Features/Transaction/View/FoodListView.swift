//
//  FoodListView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/10/23.
//

import SwiftUI

struct FoodListView: View {
    
    @State private var selectedCategory: CategoryModel? = nil
    @EnvironmentObject var vm: FoodListViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.background.primary
                .edgesIgnoringSafeArea(.top)
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Today's Promo")
                        .font(.headline)
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<2) { promo in
                                PromoCardView() // static
                                    .frame(width: 230, height: 280)
                                    .padding(.horizontal)
                                    .background(Color.background.base)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(vm.categoriesModel.indices, id: \.self) { index in
                                CategoryView(
                                    isActive: vm.categoriesModel[index] == selectedCategory,
                                    categoryModel: vm.categoriesModel[index]
                                )
                                .onTapGesture {
                                    selectedCategory = vm.categoriesModel[index]
                                }
                            }
                        }
                    }
                }
                .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(vm.itemsModel.filter { item in
                        selectedCategory == nil || item.category == selectedCategory?.name
                    }) { item in
                        let itemTransactionModel = vm.selectedItems.first { selectedItem in
                            selectedItem.item.id == item.id
                        }
                        ItemFoodCardView(itemModel: item, itemTransactionModel: itemTransactionModel ?? ItemTransactionModel(item: item, quantity: 0, totalPricePerItem: 0, totalProfitPerItem: 0, totalOmzetPerItem: 0)) { updatedItemTransaction in
                            if let index = vm.selectedItems.firstIndex(where: { $0.item.id == updatedItemTransaction.item.id }) {
                                vm.selectedItems[index] = updatedItemTransaction
                            } else {
                                vm.selectedItems.append(updatedItemTransaction)
                            }
                        }
                        
                        Divider()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.background.base)
            }
            
            if vm.selectedItems.contains(where: { $0.quantity > 0 }) {
                FloatingButtonView(
                    color: Color.text.white,
                    image: "chevron.right.circle.fill",
                    text1: "Item",
                    text2: "\(vm.selectedItems.reduce(0) { $0 + $1.totalPricePerItem }.formattedAsRupiah)",
                    quantity: vm.selectedItems.reduce(0) { $0 + $1.quantity }
                ) {
                    router.navigateToPayment(transaction: vm.selectedItems)
                    print(vm.selectedItems)
                }
            }
        }
        .onAppear {
            if vm.categoriesModel.isEmpty {
                vm.getCategories()
            }
            
            if vm.itemsModel.isEmpty {
                vm.getItems()
            }
        }
    }
}

#Preview {
    FoodListView()
}

struct CategoryView: View {
    let isActive: Bool
    var categoryModel: CategoryModel
    var body: some View {
        Text(categoryModel.name)
            .font(.subheadline)
            .fontWeight(isActive == true ? .bold : .regular)
            .padding(.horizontal, 25)
            .padding(.vertical, 8)
            .foregroundStyle(isActive == true ? Color.white : Color.text.primary100)
            .background(isActive == true ? Color.primaryColor100 : Color.primaryColor20)
            .cornerRadius(12)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primaryColor100, lineWidth: isActive == true ? 1 : 0)
            }
    }
}
