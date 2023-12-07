//
//  TotalOmzetUseCase.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 07/12/23.
//

import Foundation

class TotalOmzetUseCase: BaseUseCase {
    
    typealias Params = TotalOmzetUseCase.Param
    typealias Response = (currentMonthTotal: Int, previousMonthTotal: Int, percentageChange: Double)
    
    func execute(params: Params) -> Result<Response, Error> {
        let currentMonthTotalResult = calculateTotalOmzetInMonth(params: params)
        let previousMonthTotalResult = calculateTotalOmzetPreviousMonth(params: params)
        
        switch (currentMonthTotalResult, previousMonthTotalResult) {
        case (.success(let currentMonthTotal), .success(let previousMonthTotal)):
            let percentageChangeResult = calculatePercentageChange(currentValue: currentMonthTotal, previousValue: previousMonthTotal)
            switch percentageChangeResult {
            case .success(let percentageChange):
                return .success((currentMonthTotal, previousMonthTotal, percentageChange))
            case .failure(let error):
                return .failure(error)
            }
        case (.failure(let error), _), (_, .failure(let error)):
            return .failure(error)
        }
    }
    
    private func calculateTotalOmzetInMonth(params: Params) -> Result<Int, Error> {
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: params.date))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        let transactionsInMonth = params.transactions.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
        
        let totalOmzet = transactionsInMonth.reduce(0) { $0 + self.totalOmzet(for: $1.items) }
        
        return .success(totalOmzet)
    }
    
    private func calculateTotalOmzetPreviousMonth(params: Params) -> Result<Int, Error> {
        guard let previousMonth = Calendar.current.date(byAdding: DateComponents(month: -1), to: params.date) else {
            return .failure(ErrorType.invalidDate)
        }
        
        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: previousMonth))!
        let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        let transactionsInMonth = params.transactions.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
        let totalOmzet = transactionsInMonth.reduce(into: 0) { total, transaction in
            total += transaction.items.reduce(0) { $0 + $1.totalOmzetPerItem }
        }
        
        return .success(totalOmzet)
    }
    
    private func totalOmzet(for items: [ItemTransactionModel]) -> Int {
        return items.reduce(0) { $0 + $1.totalOmzetPerItem }
    }
    
    private func calculatePercentageChange(currentValue: Int, previousValue: Int) -> Result<Double, Error> {
        guard previousValue != 0 else {
            return .success(0.0)
        }
        
        let percentageChange = Double(currentValue - previousValue) / Double(previousValue) * 100.0
        let roundedPercentageChange = (percentageChange * 100).rounded() / 100
        
        return .success(roundedPercentageChange)
    }
    
    struct Param {
        var date: Date
        var transactions: [TransactionModel]
    }
}
