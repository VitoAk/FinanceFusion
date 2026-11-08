import SwiftData
import Foundation

@Model 
final class Contribution{
    var amount: Decimal
    var date: Date
    var goal: Goal?
    
    init(amount: Decimal, goal: Goal, date: Date = .now){
        self.amount = amount
        self.goal = goal
        self.date = date
    }
}
