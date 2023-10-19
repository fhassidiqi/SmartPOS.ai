//
//  HomeView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Today's Income")
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Rp. 243.000")
                        .font(.largeTitle).bold()
                    
                    Text("Updated 2 mins ago")
                        .font(.footnote)
                }
            }
            .foregroundColor(Color.text.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 35)
            .padding(.vertical, 20)
            .background(Color.primary100)
            
            HStack {
                Text("Transaction History")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                        .foregroundColor(Color.text.primary100)
                })
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            ScrollView {
                ForEach(0 ..< 10) { history in
                    HistoryTransactionCard()
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                }
            }
            
            Spacer()
        }
        .background(Color.backgroundPrimary)
    }
}

#Preview {
    HomeView()
}
