//
//  FloatingActionButtonView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 22/10/23.
//

import SwiftUI

struct FloatingActionButtonView: ViewModifier {
    
    let color: Color
    let image: String
    let text1: String
    let text2: String? // opsional jika button hanya 1 objek
    let action: () -> Void
    
    private let sizeWidth: CGFloat = 358
    private let sizeHeight: CGFloat = 50
    private let margin: CGFloat = 15
    
    func body(content: Content) -> some View {
        ZStack {
            Color.clear
            content
            button()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    @ViewBuilder private func button() -> some View {
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

extension View {
    func floatingActionButton(
        color: Color,
        text1: String,
        text2: String?,
        image: String,
        action: @escaping () -> Void) -> some View {
            self.modifier(FloatingActionButtonView(color: color,
                                                   image: image,
                                                   text1: text1,
                                                   text2: text2,
                                                   action: action))
        }
}
