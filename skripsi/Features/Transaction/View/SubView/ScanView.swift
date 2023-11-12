//
//  ScanView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 22/10/23.
//

import SwiftUI

struct ScanView: View {
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            
        }
        .toolbar {
            CustomToolbar(title: "Scan QR", leadingTitle: "Pay") {
                router.navigateBack()
            }
        }
    }
}

#Preview {
    ScanView()
}
