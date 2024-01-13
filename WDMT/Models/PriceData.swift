//
//  PriceData.swift
//  WDMT
//
//  Created by Robin Konijnendijk on 13/01/2024.
//

import Foundation

class PriceData {
    var prices: [Int: [Int: Int]] = [:]
    
    init() {
        setupData()
    }
    
    private func setupData() {
        prices = [
            60: [100: 125, 110: 130, 120: 134, 130: 139, 140: 144, 150: 148, 160: 153, 170: 158, 180: 162, 190: 167, 200: 172, 210: 176, 220: 181, 230: 185, 240: 190, 250: 195, 260: 199, 270: 204, 280: 209, 290: 213, 300: 218],
            70: [100: 134, 110: 140, 120: 145, 130: 150, 140: 155, 150: 160, 160: 165, 170: 170, 180: 176, 190: 181, 200: 186, 210: 191, 220: 196, 230: 201, 240: 207, 250: 212, 260: 217, 270: 222, 280: 227, 290: 232, 300: 237]
        ]
    }
    
    func calculatePrice(width: Int, height: Int) -> Int? {
        let nearestWidth = prices.keys.filter {$0 >= width}.min() ?? prices.keys.max()
        if let nearestWidth = nearestWidth, let heightPrices = prices[nearestWidth] {
            let nearestHeight = heightPrices.keys.filter {$0 >= height }.min() ?? heightPrices.keys.max()
            return nearestHeight.flatMap {heightPrices[$0]}
        }
        return nil
    }
    
    
}
