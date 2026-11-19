import Foundation

enum AppSettings{
    static let currencyCode = "EUR"
}

extension Decimal{
    var asCurrency: String{
        formatted(.currency(code: AppSettings.currencyCode))
    }
}
