//
//  FoodListView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/10/23.
//

import SwiftUI

struct FoodListView: View {
    
    @State private var selectedCategory: CategoryModel? = nil
    @ObservedObject private var vm = FoodListViewModel()
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
                                PromoCardView()
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
                        ItemFoodCardView(itemModel: item)
                        Divider()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.background.base)
            }
            
            if vm.quantity == 0 {
                
                FloatingButtonView(color: Color.primary100, image: "chevron.right.circle.fill", text1: "Item", text2: "Rp. 40.000") {
                    router.navigate(to: .pay)
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
            .foregroundStyle(isActive == true ? Color.text.white : Color.text.primary100)
            .background(isActive == true ? Color.primary100 : Color.primary20)
            .cornerRadius(12)
    }
}
