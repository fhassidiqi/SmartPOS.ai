//
//  ItemCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct ItemCardView: View {
    var body: some View {
        HStack {
            Text("Item")
            
            Spacer()
            Spacer()
            
            Text("2")
            Spacer()
            
            Text("5.500")
            Spacer()
            
            Text("11.000")
        }
    }
}

#Preview {
    ItemCardView()
}
