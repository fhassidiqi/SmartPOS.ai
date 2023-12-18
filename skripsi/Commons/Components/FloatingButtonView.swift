//
//  FloatingButtonView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/11/23.
//

import SwiftUI

struct FloatingButtonView: View {
    
    let color: Color
    let image: String?
    let text1: String
    let text2: String?
    var quantity: Int?
    let action: () -> Void
    
    private let sizeWidth: CGFloat = 358
    private let sizeHeight: CGFloat = 50
    private let margin: CGFloat = 15
    
    var body: some View {
        Button(action: action){
            HStack {
                if let text2 = (text2 != nil && quantity != 0) ? text2 : nil,
                    let imageName = (image != nil) ? image! : nil {
                    Text("\(quantity ?? 0) \(text1)")
                    
                    Spacer()
                    
                    Text(text2)
                    
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 25, height: 25)
                } else {
                    Text("\(text1)")
                }
            }
            .font(.headline)
            .padding()
            .frame(width: sizeWidth, height: sizeHeight, alignment: .center)
            .foregroundStyle(Color.text.white)
            .background(Color.primaryColor100)
            .cornerRadius(8)
            
        }
    }
}
