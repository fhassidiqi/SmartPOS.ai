//
//  HistoryTransactionCard.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct HistoryTransactionCard: View {
    
    var transactionModel: TransactionModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(transactionModel.orderNumber)
                    .font(.subheadline).bold()
                
                
                Text(formatDate(transactionModel.date))
                    .font(.caption2)
                    .foregroundStyle(Color.text.primary30)
            }
            Spacer()
            
            Text("\(transactionModel.totalTransaction)")
            
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Color.text.primary100)
        .padding()
        .background(Color.background.base)
        .cornerRadius(8)
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

struct SwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Content
    @ActionBuilder var actions: [Action]
    @State private var vm = HomeViewModel()
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .containerRelativeFrame(.horizontal)
                        .id(vm.transactionModel)
                        .transition(.identity)
                    
                    ActionButtons {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(vm.transactionModel, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
    }
    
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: direction.alignment) {
                ForEach(actions) { button in
                    Button(action: {
                        Task {
                            resetPosition()
                            try? await Task.sleep(for: .seconds(0.25))
                            button.action()
                        }
                    }, label: {
                        Image(systemName: button.icon)
                            .font(button.iconFont)
                            .foregroundStyle(button.iconTint)
                            .frame(width: 100)
                            .frame(maxHeight: .infinity)
                            .contentShape(.rect)
                    })
                    .buttonStyle(.plain)
                    .background(button.tint)
                }
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}

struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> ()
}

@resultBuilder
struct ActionBuilder {
    var transactionModel: TransactionModel
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}

// swipe direction
enum SwipeDirection {
    case leading, trailing
    
    var alignment: Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}
