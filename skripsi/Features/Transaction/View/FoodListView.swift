//
//  FoodListView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/10/23.
//

import SwiftUI

struct FoodListView: View {
    
    @State private var selectedIndex = 0
    private let categories = ["All", "Coffee", "Meal", "Snack", "Dessert"]
    private let isActive = false
    @EnvironmentObject private var route: ContentViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.primary
                    .edgesIgnoringSafeArea(.top)
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
                            ForEach(0 ..< categories.count, id: \.self) { item in
                                CategoryView(isActive: item == selectedIndex, text: categories[item])
                                    .onTapGesture {
                                        selectedIndex = item
                                    }
                            }
                        }
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(0..<4) { item in
                            ItemFoodCardView()
                            Divider()
                        }
                    }
                }
                .padding()
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
        .floatingActionButton(color: Color.primary100, text1: "Item", text2: "Rp. 129.000", image: "chevron.right.circle.fill", action: {})
    }
}

#Preview {
    FoodListView()
}

struct CategoryView: View {
    let isActive: Bool
    let text: String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(isActive == true ? .bold : .regular)
            .padding(.horizontal, 25)
            .padding(.vertical, 8)
            .foregroundStyle(isActive == true ? Color.text.white : Color.text.primary100)
            .background(isActive == true ? Color.primary100 : Color.primary20)
            .cornerRadius(12)
    }
}
