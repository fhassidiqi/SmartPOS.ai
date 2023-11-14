//
//  FloatingButtonView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/11/23.
//

import SwiftUI

struct FloatingButtonView: View {
    
    let color: Color
    let image: String
    let text1: String
    let text2: String?
    let action: () -> Void
    
    private let sizeWidth: CGFloat = 358
    private let sizeHeight: CGFloat = 50
    private let margin: CGFloat = 15
    
    var body: some View {
        Button(action: action){
            HStack {
                
                Text(text1)
                
                if let text2 {
                    Spacer()
                    
                    Text(text2)
                    
                    Image(systemName: image)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            .font(.headline)
            .padding()
            .frame(width: sizeWidth, height: sizeHeight)
            .foregroundStyle(Color.text.white)
            .background(Color.primaryColor100)
            .cornerRadius(8)
            
        }
    }
}
