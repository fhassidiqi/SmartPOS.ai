//
//  DetailHistoryView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct DetailHistoryView: View {
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Detail Transaction")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding(.horizontal)
    }
}

#Preview {
    DetailHistoryView()
}
