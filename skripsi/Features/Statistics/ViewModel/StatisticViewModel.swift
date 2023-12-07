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
    
    @Published var monthlyOmzetTotals: [String: Int] = [:]
    
    @Published var fetchingData = false
    @Published var transactionModel = [TransactionModel]()
    
    private let totalOmzetPerSemesterUseCase = TotalOmzetLastSixMonthUseCase()
    private let totalOmzetUseCase = TotalOmzetUseCase()
    private let totalProfitUseCase = TotalProfitUseCase()
    private let getTransactionUseCase = GetTransactionUseCase()
    
    func getTransactions() async {
        Task {
            let result = await getTransactionUseCase.execute(params: GetTransactionUseCase.Params())
            
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
            await getTransactions()
            await calculateTotalOmzet(forMonth: date)
            await calculateTotalProfit(forMonth: date)
            
        }
    }
    
    func updateChartData(for date: Date) async {
        Task {
            await calculateTotalOmzetForMonths(date: date)
        }
    }
    
    func calculateTotalOmzet(forMonth date: Date) async {
        Task {
            DispatchQueue.main.sync {
                self.fetchingData = true
            }
            
            let params = TotalOmzetUseCase.Params(date: date, transactions: transactionModel)
            let result = totalOmzetUseCase.execute(params: params)
            
            switch result {
            case .success(let (currentMonth, previousMonth, percentageChange)):
                DispatchQueue.main.sync {
                    self.omzetInMonth = currentMonth
                    self.omzetPreviousMonth = previousMonth
                    self.omzetPercentage = percentageChange
                    self.fetchingData = false
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.fetchingData = false
                }
                break
            }
        }
    }
    
    func calculateTotalProfit(forMonth date: Date) async {
        Task {
            DispatchQueue.main.sync {
                self.fetchingData = true
            }
            
            let params = TotalProfitUseCase.Params(date: date, transactions: transactionModel)
            let result = totalProfitUseCase.execute(params: params)
            
            switch result {
            case .success(let (currentMonth, previousMonth, percentageChange)):
                DispatchQueue.main.sync {
                    self.profitInMonth = currentMonth
                    self.profitPreviousMonth = previousMonth
                    self.profitPercentage = percentageChange
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.fetchingData = false
                }
                break
            }
        }
    }
    
    func calculateTotalOmzetForMonths(date: Date) async {
        Task {
            DispatchQueue.main.sync {
                self.fetchingData = true
            }
            
            let params = TotalOmzetLastSixMonthUseCase.Param(date: date, transactions: transactionModel)
            let result = totalOmzetPerSemesterUseCase.execute(params: params)
            
            switch result {
            case .success(let monthlyTotals):
                DispatchQueue.main.sync {
                    self.monthlyOmzetTotals = monthlyTotals
                    self.fetchingData = false
                }
            case .failure(let error):
                print("Error: \(error)")
                DispatchQueue.main.sync {
                    self.fetchingData = false
                }
            }
        }
    }
}
