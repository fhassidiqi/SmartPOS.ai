//
//  StatisticViewModel.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 04/12/23.
//

import Foundation

class StatisticViewModel: ObservableObject {
    
    @Published var omzetInMonth  = 0
    @Published var profitInMonth = 0
    @Published var omzetPercentage = 0.0
    @Published var profitPercentage = 0.0
    @Published var omzetPreviousMonth = 0
    @Published var profitPreviousMonth = 0
    
    @Published var fetchingOmzetData: Bool = false
    @Published var fetchingProfitData: Bool = false
    @Published var transactionModel = [TransactionModel]()
    
    private let totalOmzetUseCase = TotalOmzetUseCase()
    private let totalProfitUseCase = TotalProfitUseCase()
    private let getTransactionUseCase = GetTransactionUseCase()
    
    func getTransactions() {
        Task {
            let params = GetTransactionUseCase.Params()
            let result = await getTransactionUseCase.execute(params: params)
            
            switch result {
            case .success(let transaction):
                DispatchQueue.main.sync {
                    self.transactionModel = transaction
                }
                break
            case .failure(let error):
                print("Error fetching transaction: \(error)")
                break
            }
        }
    }
    
    func updateData(for date: Date) async {
        Task {
            getTransactions()
            calculateTotalOmzet(forMonth: date)
            await calculateTotalProfit(forMonth: date)
        }
    }
    
    func calculateTotalOmzet(forMonth date: Date) {
        Task {
            DispatchQueue.main.sync {
                self.fetchingOmzetData = true
            }
            
            let params = TotalOmzetUseCase.Params(date: date, transactions: transactionModel)
            let result = totalOmzetUseCase.execute(params: params)
            
            switch result {
            case .success(let (currentMonth, previousMonth, percentageChange)):
                DispatchQueue.main.sync {
                    self.omzetInMonth = currentMonth
                    self.omzetPreviousMonth = previousMonth
                    self.omzetPercentage = percentageChange
                    self.fetchingOmzetData = false
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.fetchingOmzetData = false
                }
                break
            }
        }
    }
    
    func calculateTotalProfit(forMonth date: Date) async {
        Task {
            DispatchQueue.main.sync {
                self.fetchingProfitData = true
            }
            
            let params = TotalProfitUseCase.Params(date: date, transactions: transactionModel)
            let result = totalProfitUseCase.execute(params: params)
            
            switch result {
            case .success(let (currentMonth, previousMonth, percentageChange)):
                DispatchQueue.main.sync {
                    self.profitInMonth = currentMonth
                    self.profitPreviousMonth = previousMonth
                    self.profitPercentage = percentageChange
                    self.fetchingProfitData = false
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.fetchingProfitData = false
                }
                break
            }
        }
    }
}
