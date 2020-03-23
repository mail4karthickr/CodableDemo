//
//  ResponseData.swift
//  CodableDemo
//
//  Created by Karthick Ramasamy on 3/21/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
    var accounts: [Account]
    var categories: [Category]?
    
    var hasCategories: Bool {
        guard let categories = self.categories, categories.count > 0 else {
            return false
        }
        return true
    }
}

struct Account: Decodable {
    var name: String
    var number: String
    var type: String
    var balance: String
    var maskedAccountNumber: String
}

struct Category {
    let name: String
    let balance: String
    let accounts: [Account]
}

extension ResponseData {
    
    enum ResponseContainer: String, CodingKey {
        case accounts
        case categories
    }
    
    struct CategoryKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
        
        static let categories = CategoryKey(stringValue: "categories")!
        static let name = CategoryKey(stringValue: "name")!
        static let balance = CategoryKey(stringValue: "balance")!
        static let accountId = CategoryKey(stringValue: "accountId")!
        static let accounts = CategoryKey(stringValue: "accounts")!
    }

    init(from decoder: Decoder) throws {
        let responseContainer = try decoder.container(keyedBy: ResponseContainer.self)
        let accounts = try responseContainer.decode([Account].self, forKey: .accounts)
 
        
        let categoriesContainer = try responseContainer.nestedContainer(keyedBy: CategoryKey.self, forKey: .categories)
        

        var categories = [Category]()
        for key in categoriesContainer.allKeys {
            let categoryContainer = try categoriesContainer.nestedContainer(keyedBy: CategoryKey.self, forKey: key)
            let balance = try categoryContainer.decode(String.self, forKey: .balance)
            var accountsIdContainer = try categoryContainer.nestedUnkeyedContainer(forKey: .accountId)
            var accounts1 = [Account]()
            while (!accountsIdContainer.isAtEnd) {
                let accountId = try accountsIdContainer.decode(String.self)
                let acc = accounts.filter { $0.name == accountId }
                let dd = acc.first
                accounts1.append(dd!)
            }
            let category = Category(name: key.stringValue, balance: balance, accounts: accounts1)
            categories.append(category)
        }
        self.init(accounts: accounts, categories: categories)
    }
}
