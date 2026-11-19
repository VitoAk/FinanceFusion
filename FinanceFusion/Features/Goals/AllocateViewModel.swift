import SwiftData
import Foundation

@Observable //Enables SwiftUI to make changes to the values inside the class
final class AllocateViewModel{
    var amountText: String = ""
    
    var amount: Decimal? {Decimal(string: amountText, locale: .current)}
    var isValid: Bool{(amount ?? 0) > 0} //if amount is nil use 0, else use its value
    
    func setQuick(_ value: Decimal){ //_ tells the function that it doesnt need a named paramet e.g. setQuick(1240)
        amountText = value.formatted()
    }
    
    func save(to goal: Goal, in context: ModelContext){
        guard let amount, amount > 0 else {return}
        context.insert(Contribution(amount: amount, goal: goal))
    }
}
