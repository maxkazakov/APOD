//
//  Date+Extention.swift
//  ASOD
//
//  Created by Максим Казаков on 15/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation

extension Date {
    func getDateFor(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
    
    func daysOffset(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
}
