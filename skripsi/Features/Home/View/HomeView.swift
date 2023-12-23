//
//  HomeView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 14/10/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var vm = HomeViewModel()
    @EnvironmentObject var router: Router
    @State private var sortOption: SortType = .date
    
    var body: some View {
        ZStack {
            Color.background.primary
                .edgesIgnoringSafeArea(.top)
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Income")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(vm.incomeTransaction[0].formattedAsRupiah)
                            .font(.largeTitle).bold()
                        
                        Text("Updated **2 mins ago**")
                            .font(.footnote)
                    }
                    .padding(.bottom, 20)
                }
                .foregroundColor(Color.text.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 35)
                .padding(.vertical, 20)
                .background(
                    UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 40, bottomTrailing: 40))
                        .ignoresSafeArea()
                        .foregroundStyle(Color.primaryColor100)
                )
                
                HStack {
                    Text("Transaction History")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            switch sortOption {
                            case .cashier: sortOption = .orderNumber
                            case .orderNumber: sortOption = .date
                            case .date: sortOption = .cashier
                            }
                            
                            vm.sortTransactions(by: sortOption)
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(Color.text.primary100)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                ScrollView(.vertical) {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.transactionModel, id: \.self) { transaction in
                            SwipeAction(cornerRadius: 15, direction: .trailing) {
                                HistoryView(transaction)
                            } actions: {
                                Action(tint: .red, icon: "trash.fill") {
                                    withAnimation(.easeInOut) {
                                        vm.deleteTransaction(transactionId: transaction.id.orEmpty())
                                    }
                                    
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .scrollIndicators(.hidden)
                
                Spacer()
            }
        }
        .onAppear {
            vm.getTransactions()
        }
    }
    
    @ViewBuilder
    func HistoryView(_ transactionModel: TransactionModel) -> some View {
        
        Button {
            router.navigateToDetailTransaction(transaction: transactionModel)
        } label: {
            if vm.fetchingTransaction {
                Rectangle()
                    .foregroundStyle(Color.text.primary100)
                    .padding()
                    .background(Color.background.base)
                    .cornerRadius(8)
                    .shimmer()
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(transactionModel.orderNumber)
                            .font(.subheadline).bold()
                        
                        Text(transactionModel.date.formatDateMedium)
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
        }
    }
}

#Preview {
    HomeView()
}
