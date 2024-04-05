//
//  Item.swift
//  Pay2dc_Assignment_vikash_Kumar
//
//  Created by Vikash Kumar on 05/04/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
