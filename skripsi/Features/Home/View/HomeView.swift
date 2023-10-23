//
//  HomeView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var router: Router
    
    var body: some View {
        ZStack {
            Color.background.primary
                .edgesIgnoringSafeArea(.top)
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Income")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Rp. 243.000")
                            .font(.largeTitle).bold()
                        
                        Text("Updated **2 mins ago**")
                            .font(.footnote)
                    }
                    .padding(.bottom, 20)
                }
                .foregroundColor(Color.text.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 35)
                .padding(.vertical, 20)
                .background(
                    UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 40, bottomTrailing: 40))
                        .ignoresSafeArea()
                        .foregroundStyle(Color.primary100)
                )
                
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
                
                Button {
                    router.navigate(to: .detailTransaction)
                } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("SHP 030923001")
                            .font(.subheadline).bold()
                        
                        
                        Text("03 Sep 2023, 10:20 WIB")
                            .font(.caption2)
                            .foregroundStyle(Color.text.primary30)
                    }
                    Spacer()
                    
                    Text("Rp. 32.500")
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(Color.text.primary100)
                .padding()
                .background(Color.background.base)
                .cornerRadius(8)
                .padding(.horizontal)
                
                
                Spacer()
            }
        }
    }
}

#Preview {
    HomeView()
}
