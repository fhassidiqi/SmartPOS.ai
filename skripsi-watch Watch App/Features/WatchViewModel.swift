//
//  WatchViewModel.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 22/12/23.
//
//import Foundation
//import Combine
//
//class WatchViewModel: ObservableObject {
//    
//    let watchConnector = WatchSessionDelegate(PassthroughSubject<[SerializedIncome], Never>([]))
//    @Published var todayIncome = ""
//
//    private var cancellables: Set<AnyCancellable> = []
//
//    // Expose a method to update income data
//    func updateIncome() {
//        watchConnector.dataSubject
//            .map { incomes in
//                // Process your income data here if needed
//                // For example, combine multiple incomes into a single string
//                return incomes.map { "\($0.income)" }.joined(separator: ", ")
//            }
//            .assign(to: \.todayIncome, on: self)
//            .store(in: &cancellables)
//    }
//}
