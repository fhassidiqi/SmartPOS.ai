//
//  CustomTabBar.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI

struct CustomTabBar: View {
    
    @State var index = 0
    var body: some View {
        VStack {
            Spacer()
            
            CustomTabs(index: self.$index)
        }
        .background(Color.primary20).edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    CustomTabBar()
}

struct CustomTabs: View {
    
    @Binding var index: Int
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                self.index = 0
            } label: {
                VStack {
                    Image(systemName: "house")
                    
                    Text("Home")
                        .font(.caption2)
                }
                .foregroundStyle(self.index == 0 ? Color.primary100 : Color.text.primary30)
            }
            
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 55, height: 55)
            }
            .offset(x: 9, y: -35)
            
            
            Spacer()
            
            Button {
                self.index = 1
            } label: {
                VStack {
                    Image(systemName: "chart.bar.fill")
                    
                    Text("Statistics")
                        .font(.caption2)
                        
                }
                .foregroundStyle(self.index == 1 ? Color.primary100 : Color.text.primary30)
            }
            
            Spacer()

        }
        .padding(.top, 50)
        .padding(.bottom, 5)
        .background(Color.background.base)
        .clipShape(CShape())
    }
}

struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 45))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 45))
            
            path.addArc(center: CGPoint(x: rect.width / 2, y: 45), radius: 30, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: true)
        }
    }
}
