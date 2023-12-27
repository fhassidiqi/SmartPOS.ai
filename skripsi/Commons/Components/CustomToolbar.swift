//
//  CustomToolbar.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/11/23.
//

import SwiftUI

struct CustomToolbar: ToolbarContent {
    
    let title: String
    let leadingTitle: String
    let leadingAction: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.text.white)
        }
        
        ToolbarItem(placement: .topBarLeading) {
            Button {
                leadingAction()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.callout)
                    
                    Text(leadingTitle)
                        .font(.headline)
                }
                .foregroundStyle(Color.text.white)
            }
        }
    }
}

