import Foundation

class TotalOmzetLastSixMonthUseCase: BaseUseCase {

    typealias Params = TotalOmzetLastSixMonthUseCase.Param
    typealias Response = [String: Int]

    func execute(params: Params) -> Result<Response, Error> {
        let currentMonthTotalResult = calculateTotalOmzetInMonth(params: params)
        let lastSixMonthsTotalResult = calculateTotalOmzetLastSixMonths(params: params)

        switch (currentMonthTotalResult, lastSixMonthsTotalResult) {
        case (.success(let currentMonthTotal), .success(let lastSixMonthsTotal)):
            var result: Response = ["currentMonthTotal": currentMonthTotal]
            result.merge(lastSixMonthsTotal) { (_, new) in new } // Merge dictionaries
            return .success(result)
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

    private func calculateTotalOmzetLastSixMonths(params: Params) -> Result<[String: Int], Error> {
        var totalOmzetByMonth: [String: Int] = [:]

        for i in 0..<6 {
            guard let currentDate = Calendar.current.date(byAdding: DateComponents(month: -i), to: params.date) else {
                return .failure(ErrorType.invalidDate)
            }

            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: currentDate))!
            let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: currentDate)!

            let transactionsInMonth = params.transactions.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
            let totalOmzet = transactionsInMonth.reduce(into: 0) { total, transaction in
                total += transaction.items.reduce(0) { $0 + $1.totalOmzetPerItem }
            }

            let monthKey = monthYearFormatter.string(from: currentDate)
            totalOmzetByMonth[monthKey] = totalOmzet
        }

        return .success(totalOmzetByMonth)
    }

    private func totalOmzet(for items: [ItemTransactionModel]) -> Int {
        return items.reduce(0) { $0 + $1.totalOmzetPerItem }
    }

    private let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()

    struct Param {
        var date: Date
        var transactions: [TransactionModel]
    }
}
