//
//  Date+Extention.swift
//  ASOD
//
//  Created by Максим Казаков on 15/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import Foundation


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter
}()


extension Date {
    func getDateFor(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
    
    
    func daysOffset(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    
    func withoutTime() -> Date {
        let dateStr = dateFormatter.string(from: self)
        return dateFormatter.date(from: dateStr)!
    }
}
