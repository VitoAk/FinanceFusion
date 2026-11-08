import SwiftData
import Foundation

@Model
final class Goal{ //final = class cannot be inharited
    var name: String
    var targetAmount: Decimal
    @Attribute(.externalStorage) var imageData: Data? //save references to images, not images directly to make the query faster
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Contribution.goal) //delete all contributions when deleting goal
    var contributions: [Contribution] = []
    
    init(name: String, targetAmount: Decimal, imageData: Data? = nil) {
        self.name = name
        self.targetAmount = targetAmount
        self.imageData = imageData
        self.createdAt = .now
        self.contributions = contributions
    }
    
    var savedAmount: Decimal { contributions.reduce(0) {$0 + $1.amount}} //add all contributions in to a single var
    var remainingAmount: Decimal {max(0, targetAmount - savedAmount)}
    var progress: Double{
        guard targetAmount > 0 else {return 0} //prevents dividing by zero
        let ratio = NSDecimalNumber(decimal: savedAmount/targetAmount).doubleValue
        return min(1, ratio)
    }
    
    var isReached: Bool {savedAmount >= targetAmount}
}
