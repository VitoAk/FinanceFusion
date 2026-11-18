import Foundation

enum AppSettings{
    static let currencyCode = "EUR"
}

extension Decimal{
    var asCurency: String{
        formatted(.currency(code: AppSettings.currencyCode))
    }
}
