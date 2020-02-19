//
// Shareholder Translator
// Generated on 18/02/2020 by gen v0.2
//

import AlfaFoundation
import SharedModels

struct ShareholderTranslator: Translator {
    let amountTranslator: AnyTranslator<Amount>

    init(
        amountTranslator: AnyTranslator<Amount> = .init(AmountTranslator())
    ) {
        self.amountTranslator = amountTranslator
    }

    func translateFrom(dictionary json: [String: Any]) throws -> Shareholder {
        let uid: String = try json.get(DTOKeys.id)
        let iconURL: String = try json.get(DTOKeys.iconURL)
        let name: String = try json.get(DTOKeys.name)
        let profit: Double = try json.get(DTOKeys.profit)
        guard let company = Company(rawValue: try json.get(DTOKeys.company)) else { throw TranslatorError.invalidJSONObject }
        let amount = try amountTranslator.translateFrom(dictionary: json.get(DTOKeys.amount))
        return Shareholder(
            uid: uid,
            iconURL: iconURL,
            name: name,
            company: company,
            amount: amount,
            profit: profit
        )
    }

    func translateToDictionary(_ object: Shareholder) -> [String: Any] {
        return fromDTO(
            DTOKeys.self,
            [
                .id: object.uid,
                .iconURL: object.iconURL,
                .name: object.name,
                .profit: object.profit,
                .company: object.company.rawValue,
                .amount: amountTranslator.translateToDictionary(object.amount),
            ]
        )
    }
}

extension ShareholderTranslator {
    enum DTOKeys: String {
        case id
        case iconURL
        case name
        case company
        case amount
        case profit
    }
}
