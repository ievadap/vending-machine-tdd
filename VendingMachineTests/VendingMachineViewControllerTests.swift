//
//  VendingMachineViewControllerTests.swift
//  VendingMachine
//
//  Created by Ieva on 19/04/2019.
//  Copyright © 2019 Telesoftas. All rights reserved.
//

import XCTest
@testable import VendingMachine

class VendingMachineViewControllerTests: XCTestCase {
    
    let nickelCount: Int = 5
    let dimeCount: Int = 4
    let quarterCount: Int = 3
    let dollarCount: Int = 2
    let itemACount: Int = 10
    let itemBCount: Int = 14
    let itemCCount: Int = 11
    
    let userNickelCount: Int = 2
    let userDimeCount: Int = 3
    let userQuarterCount: Int = 4
    let userDollarCount: Int = 5
    
    var viewController: VendingMachineViewController!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewController = VendingMachineViewController()
        _ = viewController.view
                
        viewController.service(nickelCount: nickelCount, dimeCount: dimeCount,
                               quarterCount: quarterCount, dollarCount: dollarCount,
                               itemACount: itemACount, itemBCount: itemBCount, itemCCount: itemCCount)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_if_vending_machine_has_coins_and_items_after_service() {
        
        XCTAssertEqual(viewController.nickelCount, nickelCount)
        XCTAssertEqual(viewController.dimeCount, dimeCount)
        XCTAssertEqual(viewController.quarterCount, quarterCount)
        XCTAssertEqual(viewController.dollarCount, dollarCount)
        XCTAssertEqual(viewController.itemA.count, itemACount)
        XCTAssertEqual(viewController.itemB.count, itemBCount)
        XCTAssertEqual(viewController.itemC.count, itemCCount)
    }
    
    func test_if_user_can_insert_coins() {
        
        let calculatedBalance: Float = 6.4
        
        viewController.insertCoins(nickelCount: userNickelCount, dimeCount: userDimeCount, quarterCount: userQuarterCount, dollarCount: userDollarCount)
        
        XCTAssertEqual(viewController.balance, calculatedBalance)
        XCTAssertEqual(viewController.nickelCount, userNickelCount + self.nickelCount)
        XCTAssertEqual(viewController.dimeCount, userDimeCount + self.dimeCount)
        XCTAssertEqual(viewController.quarterCount, userQuarterCount + self.quarterCount)
        XCTAssertEqual(viewController.dollarCount, userDollarCount + self.dollarCount)
    }
    
    func test_if_user_can_remove_item() {
        
        viewController.insertCoins(nickelCount: userNickelCount, dimeCount: userDimeCount, quarterCount: userQuarterCount, dollarCount: userDollarCount)
        
        viewController.removeItem(.A)
        viewController.removeItem(.B)
        viewController.removeItem(.C)
        
        XCTAssertEqual(viewController.itemA.count, itemACount - 1)
        XCTAssertEqual(viewController.itemB.count, itemBCount - 1)
        XCTAssertEqual(viewController.itemC.count, itemCCount - 1)
    }
    
    func test_if_balance_decreases_after_removing_an_item() {
        
        viewController.insertCoins(nickelCount: userNickelCount, dimeCount: userDimeCount, quarterCount: userQuarterCount, dollarCount: userDollarCount)
        var balance: Float = viewController.balance
        
        viewController.removeItem(.A)
        balance -= viewController.itemA.price
        XCTAssertEqual(viewController.balance, balance)

        viewController.removeItem(.B)
        balance -= viewController.itemB.price
        XCTAssertEqual(viewController.balance, balance)

        viewController.removeItem(.C)
        balance -= viewController.itemC.price
        XCTAssertEqual(viewController.balance, balance)
    }
    
    func test_if_purchase_refused_with_insufficient_balance() {
        XCTAssertFalse(viewController.removeItem(.A))
    }
    
    func test_if_purchase_approved_with_sufficient_balance() {
        viewController.insertCoins(nickelCount: userNickelCount, dimeCount: userDimeCount,
                                   quarterCount: userQuarterCount, dollarCount: userDollarCount)
        
        XCTAssertTrue(viewController.removeItem(.A))
    }
    
    func test_if_purchase_refused_when_item_out_of_stock() {
        
        viewController.service(nickelCount: 0, dimeCount: 0,
                               quarterCount: 0, dollarCount: 0,
                               itemACount: 0, itemBCount: 0, itemCCount: 0)
        viewController.insertCoins(nickelCount: 0, dimeCount: 0, quarterCount: 0, dollarCount: 5)
        
        XCTAssertFalse(viewController.removeItem(.A))
    }
    
    func test_if_change_is_returned_after_item_removed() {
        viewController.insertCoins(nickelCount: 0, dimeCount: 0, quarterCount: 0, dollarCount: 1)
        viewController.removeItem(.A)
        
        XCTAssertEqual(viewController.returnChange().sum, 0.35)
    }
}
