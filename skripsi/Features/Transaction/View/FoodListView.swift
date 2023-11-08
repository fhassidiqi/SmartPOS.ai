//
//  FoodListView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/10/23.
//

import SwiftUI

struct FoodListView: View {
    
    @State private var selectedIndex = 0
    private let isActive = false
    @EnvironmentObject private var route: ContentViewModel
    @StateObject private var vm = FoodListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                                    CategoryView(isActive: index == selectedIndex, categoryModel: vm.categoriesModel[index])
                                        .onTapGesture {
                                            selectedIndex = index
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(vm.itemsModel) { item in
                            ItemFoodCardView(itemModel: item)
                            Divider()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.background.base)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Food List")
                        .font(.headline)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarBackground(Color.primary100, for: .automatic)
        }
        .onAppear {
            if vm.categoriesModel.isEmpty {
                print("CategoriesModel is empty before fetching")
                vm.getCategories()
            } else {
                print("CategoriesModel already has data:", vm.categoriesModel)
            }
            
            if vm.itemsModel.isEmpty {
                vm.getItems()
            }
        }
        .floatingActionButton(color: Color.primary100, text1: "Item", text2: "Rp. 129.000", image: "chevron.right.circle.fill", action: {})
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
