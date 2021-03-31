//
// Shareholder Translator
// Generated on 30/03/2021 by gen v0.5.3
//

import AlfaFoundation
import SharedModels

struct ShareholderTranslator: Translator {
    let customAmountTranslator: AnyTranslator<Amount>

    init(
        customAmountTranslator: AnyTranslator<Amount> = .init(CustomAmountTranslator())
    ) {
        self.customAmountTranslator = customAmountTranslator
    }

    func translateFrom(dictionary json: [String: Any]) throws -> Shareholder {
        let uid: String = try json.get(DTOKeys.id)
        let iconURL: String = try json.get(DTOKeys.iconURL)
        let name: String = try json.get(DTOKeys.name)
        let profit: Double = try json.get(DTOKeys.profit)
        guard let company = Company(rawValue: try json.get(DTOKeys.company)) else {
            throw TranslatorError.invalidJSONObject
        }
        let amount = try? customAmountTranslator.translateFrom(dictionary: json.get(DTOKeys.amount))
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
        var json = fromDTO(
            DTOKeys.self,
            [
                .id: object.uid,
                .iconURL: object.iconURL,
                .name: object.name,
                .profit: object.profit,
                .company: object.company.rawValue,
            ]
        )
        json.setUnlessEmptyOrNil(customAmountTranslator.translateToDictionary(from: object.amount, forKey: DTOKeys.amount))
        return json
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
