//
//  CustomSwipeAction.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/11/23.
//

import SwiftUI

struct CustomSwipeAction: View {
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
