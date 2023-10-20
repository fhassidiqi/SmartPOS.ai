//
//  ItemPayCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct ItemPayCardView: View {
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Bottegea’s Fried Rice")
                    .font(.headline)
                
                Text("Rp. 129.000")
                    .font(.footnote)
                
                HStack(spacing: 16) {
                    Button(action: {
                        
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

#Preview {
    ItemPayCardView()
}
