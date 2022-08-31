// Source: https://stackoverflow.com/questions/68232398/cleanest-way-to-sort-an-array-of-dates-by-month-day-ignoring-the-year

import Foundation

extension Date {
    
    struct MonthDay: Comparable {
        let month: Int
        let day: Int
        
        init(date: Date?) {
            let comps = Calendar.current.dateComponents([.month,.day], from: date ?? Date())
            self.month = comps.month ?? .zero
            self.day = comps.day ?? .zero
        }
        
        static func < (lhs: MonthDay, rhs: MonthDay) -> Bool {
            lhs.month < rhs.month || (lhs.month == rhs.month && lhs.day < rhs.day)
        }
    }
}
