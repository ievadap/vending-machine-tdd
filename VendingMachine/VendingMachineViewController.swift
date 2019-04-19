//
//  VendingMachineViewController.swift
//  VendingMachine
//
//  Created by Ieva on 19/04/2019.
//  Copyright © 2019 Telesoftas. All rights reserved.
//

import UIKit

struct Item {
    var type: ItemType
    var price: Float
    var count: Int
}

enum ItemType {
    case A
    case B
    case C
}

struct Coin {
    var type: CoinType
    var count: Int
}

enum CoinType: Float {
    case nickel = 0.05
    case dime = 0.1
    case quarter = 0.25
    case dollar = 1
}

class VendingMachineViewController: UIViewController {
    
    // MARK: - Declarations
    private(set) var balance: Float = 0
    
    private(set) var coinList: [Coin] = []
    
    private(set) var itemA: Item!
    private(set) var itemB: Item!
    private(set) var itemC: Item!
    
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemA = Item(type: .A, price: 0.65, count: 0)
        itemB = Item(type: .B, price: 1, count: 0)
        itemC = Item(type: .C, price: 1.5, count: 0)
        
        coinList.append(Coin(type: .nickel, count: 0))
        coinList.append(Coin(type: .dime,  count: 0))
        coinList.append(Coin(type: .quarter, count: 0))
        coinList.append(Coin(type: .dollar, count: 0))
    }
    
    func service(nickelCount: Int, dimeCount: Int,
                 quarterCount: Int, dollarCount: Int,
                 itemACount: Int, itemBCount: Int, itemCCount: Int) {
        
        updateCoinList(nickelCount: nickelCount, dimeCount: dimeCount,
                       quarterCount: quarterCount, dollarCount: dollarCount)
        
        itemA.count = itemACount
        itemB.count = itemBCount
        itemC.count = itemCCount
    }
    
    func updateCoinList(nickelCount: Int, dimeCount: Int, quarterCount: Int, dollarCount: Int) {
        
        for index in 0..<coinList.count {
            switch coinList[index].type {
            case .nickel:
                coinList[index].count += nickelCount
            case .dime:
                coinList[index].count += dimeCount
            case .quarter:
                coinList[index].count += quarterCount
            case .dollar:
                coinList[index].count += dollarCount
            }
        }
    }
    
    func insertCoins(nickelCount: Int, dimeCount: Int, quarterCount: Int, dollarCount: Int) {
        
        
        updateCoinList(nickelCount: nickelCount, dimeCount: dimeCount,
                       quarterCount: quarterCount, dollarCount: dollarCount)
        
        balance += CoinType.nickel.rawValue * Float(nickelCount)
        balance += CoinType.dime.rawValue  * Float(dimeCount)
        balance += CoinType.quarter.rawValue  * Float(quarterCount)
        balance += CoinType.dollar.rawValue  * Float(dollarCount)
    }
    
    @discardableResult
    func removeItem(_ itemType: ItemType) -> Bool {
        
        switch itemType {
        case .A:
            return reduceCount(for: &itemA)
        case .B:
            return reduceCount(for: &itemB)
        case .C:
            return reduceCount(for: &itemC)
        }
    }
    
    func reduceCount(for item: inout Item) -> Bool {
        
        guard item.count > 0 else {
            return false
        }
        
        guard balance >= item.price else {
            return false
        }
        
        balance -= item.price
        item.count -= 1
        
        return true
    }
    
    func returnChange() -> [Coin] {
        
        var changeCoinList: [Coin] = []
        coinList.sort { (leftCoin: Coin, rightCoin: Coin) -> Bool in
            return leftCoin.type.rawValue > rightCoin.type.rawValue
        }
        
        for changeCoin in coinList {
            let multiplier = floor(balance / CoinType.dollar.rawValue)
            
            changeCoinList.append(<#T##newElement: Coin##Coin#>)
        }
        
        return coinList
    }
}

//extension Array where Element == Coin {
//
//    func coin(by type: CoinType) -> Coin {
//
//        return self.first { (coin: Coin) -> Bool in
//            return coin.type == type
//        } ?? Coi
//    }
//}
