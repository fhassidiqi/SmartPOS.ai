//
//  PromoCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 16/10/23.
//

import SwiftUI

struct PromoCardView: View {
    var body: some View {
        VStack (spacing: 12) {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(width: 20, height: 10))
                    .frame(height: 170)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.quartenaryColor)
                
                Image("makan")
                    .resizable()
                    .frame(width: 125, height: 125)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Fruity Fun")
                    .font(.headline)
                
                Text("Rp. 35.000")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Rp. 25.000")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.text.blue)
        }
    }
}

#Preview {
    PromoCardView()
}
