//
//  WatchViewModel.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 22/12/23.
//
import Foundation

class WatchViewModel: ObservableObject {
    
    @Published var todayIncome: Int = 0
    @Published var yesterdayIncome: Int = 0
    @Published var currentMonthOmzet: Int = 0
    @Published var previousMonthOmzet: Int = 0
    @Published var currentMonthProfit: Int = 0
    @Published var previousMonthProfit: Int = 0
    
    func percentageChange(current: Int, previous: Int) -> Double {
        let change = Double(current - previous)
        return change / Double(previous) * 100
    }
}
