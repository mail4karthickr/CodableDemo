//
//  ViewController.swift
//  CodableDemo
//
//  Created by Karthick Ramasamy on 3/20/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileURL = Bundle.main.url(forResource:"test", withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        let jsonStr = String(bytes: data, encoding: .utf8)!
        print("jsonStr-- \(jsonStr)")
        
        do {
            let decodedValue = try JSONDecoder().decode(ResponseData.self, from: data)
            print("decodedValue --- \(decodedValue)")
        } catch {
            print("parsing errror --- \(error)")
        }
    }
}
