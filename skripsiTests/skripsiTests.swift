//
//  skripsiTests.swift
//  skripsiTests
//
//  Created by Falah Hasbi Assidiqi on 03/01/24.
//

import XCTest
@testable import skripsi

final class skripsiTests: XCTestCase {
    
    var viewModelTransaction: FoodListViewModel!
    var viewModelHome: HomeViewModel!
    var viewModelStatistics: StatisticViewModel!
    var item: ItemModel!
    var itemTransaction: ItemTransactionModel!
    var transaction: TransactionModel!
    
    override func setUpWithError() throws {
        viewModelTransaction = FoodListViewModel()
        viewModelHome = HomeViewModel()
        viewModelStatistics = StatisticViewModel()
        item = ItemModel(id: "3x31FyFbtBdGlH5xC2NH", name: "Ayam Bakar Rica Rica", imageUrl: "https://firebasestorage.googleapis.com/v0/b/skripsi-417a0.appspot.com/o/items%2FAyam%20bakar%20rica-rica.png?alt=media&token=ba1137f5-dc60-455f-ae61-3fbc470cb6c2", description: "Grilled chicken marinated in a spicy rica-rica sauce, served with aromatic coconut rice and grilled vegetables.", category: "Meals", omzet: 27000, profit: 15000, price: 27000, discount: 0)
        itemTransaction = ItemTransactionModel(item: item, quantity: 2, totalPricePerItem: 54000, totalProfitPerItem: 30000, totalOmzetPerItem: 54000)
        transaction = TransactionModel(id: "1", orderNumber: "060120241019", date: Date(), items: [itemTransaction], cashier: "Falah Hasbi Assidiqi", totalTransactionBeforeTax: 54000, tax: 5400, totalTransaction: 59400)
    }
    
    override func tearDownWithError() throws {
        viewModelTransaction = nil
        viewModelHome = nil
        viewModelStatistics = nil
    }
    
    func testGetCategories() {
        let expectation = expectation(description: "Fetching categories")
        
        viewModelTransaction.getCategories()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertTrue(!self.viewModelTransaction.categoriesModel.isEmpty, "Categories should not be empty after fetching")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testGetItems() {
        let expectation = expectation(description: "Fetching items")
        
        viewModelTransaction.getItems()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertTrue(!self.viewModelTransaction.itemsModel.isEmpty, "Items should not be empty after fetching")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3.0, handler: nil)
    }
    
    func testAddTransaction() {
        let mockItem = item
        let itemTransaction = ItemTransactionModel(item: mockItem!, quantity: 2, totalPricePerItem: 10000, totalProfitPerItem: 4, totalOmzetPerItem: 6)
        
        viewModelTransaction.selectedItems = [itemTransaction]
        
        let expectation = XCTestExpectation(description: "Adding transaction")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModelTransaction.addTransaction(date: Date())
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testDeleteTransaction() {
        let mockItem = item
        
        viewModelHome.deleteTransaction(transactionId: mockItem?.id ?? "")
        
        let expectation = XCTestExpectation(description: "Deleting transaction")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModelHome.deleteTransaction(transactionId: mockItem?.id ?? "")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testIncrementQuantity() {
        let mockItem = item
        let mockSelectedItem = ItemTransactionModel(item: mockItem!, quantity: 2, totalPricePerItem: 10000, totalProfitPerItem: 4, totalOmzetPerItem: 6)
        
        viewModelTransaction.incrementQuantity(for: mockItem!)
        
        let expectation = XCTestExpectation(description: "Incrementing quantity")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(self.viewModelTransaction.selectedItems[0].quantity, mockSelectedItem.quantity + 1, "Quantity should be incremented by 1")
            expectation.fulfill()
        }
    }
    
    func testCalculateTotalPrice() {
        let itemTransaction1 = ItemTransactionModel(item: item, quantity: 2, totalPricePerItem: 10000, totalProfitPerItem: 4, totalOmzetPerItem: 6)
        let itemTransaction2 = ItemTransactionModel(item: item, quantity: 3, totalPricePerItem: 21000, totalProfitPerItem: 9, totalOmzetPerItem: 12)
        
        viewModelTransaction.selectedItems = [itemTransaction1, itemTransaction2]
        
        let expectation = XCTestExpectation(description: "Calculating total price")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let totalPrice = self.viewModelTransaction.calculateTotalPrice()
            XCTAssertEqual(totalPrice, 31000, "Total price calculation is incorrect")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testCalculateTotalOmzet() {
        
        let mockDate = Date()
        let mockTransactions: [TransactionModel?] = [transaction]
        let validTransactions = mockTransactions.compactMap { $0 }
        
        viewModelStatistics.transactionModel = validTransactions
        viewModelStatistics.calculateTotalOmzet(forMonth: mockDate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            let expectedOmzetInMonth = 54000
            let expectedOmzetPreviousMonth = 0
            let expectedOmzetPercentage = 100.0
            
            XCTAssertEqual(self.viewModelStatistics.omzetInMonth, expectedOmzetInMonth, "Incorrect total omzet for the current month")
            XCTAssertEqual(self.viewModelStatistics.omzetPreviousMonth, expectedOmzetPreviousMonth, "Incorrect total omzet for the previous month")
            XCTAssertEqual(self.viewModelStatistics.omzetPercentage, expectedOmzetPercentage, "Incorrect omzet percentage change")
            XCTAssertFalse(self.viewModelStatistics.fetchingOmzetData, "Fetching flag should be set to false after calculation")
        }
    }
    
    
    func testPerformanceExample() throws {
        
        measure {
            
        }
    }
    
}
