//
//  FoodListView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/10/23.
//

import SwiftUI

struct FoodListView: View {
    var body: some View {
        ZStack {
            Color.background.primary
                .ignoresSafeArea()
            NavigationStack {
                Text("Today's Promo")
                    .font(.headline)
                
                ScrollView {
                    HStack {
                        PromoCardView()
                            .frame(width: 230, height: 280)
                            .background(Color.background.base)
                    }
                }
            }
        }
    }
}

#Preview {
    FoodListView()
}
