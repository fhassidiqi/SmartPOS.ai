//
//  DetailHistoryView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct DetailHistoryView: View {
    
    @EnvironmentObject private var router: ContentViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.primary
                    .edgesIgnoringSafeArea(.top)
                VStack(spacing: 5) {
                    Text("Total Belanja")
                        .font(.headline)
                        .padding(.top, 25)
                    
                    Text("Rp. 32.500")
                        .font(.title).bold()
                    
                    Divider()
                        .padding(.vertical)
                    
                    HStack {
                        Text("Order Number")
                            .foregroundStyle(Color.text.primary30)
                        
                        Spacer()
                        
                        Text("SHP 030123001")
                            .foregroundStyle(Color.text.primary100)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Text("Order Date")
                            .foregroundStyle(Color.text.primary30)
                        
                        Spacer()
                        
                        Text("03 Sep 2023, 10:20 WIB")
                            .foregroundStyle(Color.text.primary100)
                    }
                    .font(.subheadline)
                    
                    Divider()
                        .padding(.vertical)
                    
                    ForEach(0..<5) { item in
                        ItemCardView()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Detail Transaction")
                        .font(.headline)
                        .foregroundStyle(Color.text.white)
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarBackground(Color.primary100, for: .automatic)
        }
    }
}

#Preview {
    DetailHistoryView()
}
