//
// Model Translator
// Generated on 30/03/2021 by gen v0.5.3
//

import AlfaFoundation

struct ModelTranslator: Translator {
    let amountTranslator: AnyTranslator<Amount>

    init(
        amountTranslator: AnyTranslator<Amount> = .init(AmountTranslator())
    ) {
        self.amountTranslator = amountTranslator
    }

    func translateFrom(dictionary json: [String: Any]) throws -> Model {
        let someHash: [String: Any] = try json.get(DTOKeys.someHash)
        let someOptionalHash: [String: Any]? = try? json.get(DTOKeys.someOptionalHash)
        let customProperty = try amountTranslator.translateFrom(dictionary: json.get(DTOKeys.customProperty))
        let customOptionalProperty = try? amountTranslator.translateFrom(dictionary: json.get(DTOKeys.customOptionalProperty))
        let customArray = try amountTranslator.translateFrom(array: json.get(DTOKeys.customArray))
        let customOptionalArray = try? amountTranslator.translateFrom(array: json.get(DTOKeys.customOptionalArray))
        let optUrl = URL(string: (try? json.get(DTOKeys.optUrl)) ?? "")
        guard let normURL = URL(string: try json.get(DTOKeys.normURL)) else {
            throw TranslatorError.invalidJSONObject
        } 
        let someDecimalDouble: Double = try json.get(DTOKeys.someDecimal)
        let someDecimal = Decimal(someDecimalDouble)
        var someOptionalDecimal: Decimal?
        if let someOptionalDecimalDouble: Double = try? json.get(DTOKeys.someOptionalDecimal) {
            someOptionalDecimal = Decimal(someOptionalDecimalDouble)
        }
        return Model(
            optUrl: optUrl,
            normURL: normURL,
            someHash: someHash,
            someOptionalHash: someOptionalHash,
            someDecimal: someDecimal,
            someOptionalDecimal: someOptionalDecimal,
            customProperty: customProperty,
            customOptionalProperty: customOptionalProperty,
            customArray: customArray,
            customOptionalArray: customOptionalArray
        )
    }

    func translateToDictionary(_ object: Model) -> [String: Any] {
        var json = fromDTO(
            DTOKeys.self,
            [
                .someHash: object.someHash,
                .customProperty: amountTranslator.translateToDictionary(from: object.customProperty),
                .customArray: amountTranslator.translateToArray(object.customArray),
                .normURL: object.normURL.absoluteString,
                .someDecimal: (object.someDecimal as NSDecimalNumber).doubleValue,
            ]
        )
        json.setUnlessNil(object.someOptionalHash, forKey: DTOKeys.someOptionalHash)
        json.setUnlessNil(object.optUrl?.absoluteString, forKey: DTOKeys.optUrl)
        json.setUnlessNil((object.someOptionalDecimal as NSDecimalNumber?)?.doubleValue, forKey: DTOKeys.someOptionalDecimal)
        json.setUnlessEmptyOrNil(amountTranslator.translateToDictionary(from: object.customOptionalProperty, forKey: DTOKeys.customOptionalProperty))
        json.setUnlessEmptyOrNil(amountTranslator.translateToArray(object.customOptionalArray, forKey: DTOKeys.customOptionalArray))
        return json
    }
}

extension ModelTranslator {
    enum DTOKeys: String {
        case optUrl
        case normURL = "normUrl"
        case someHash
        case someOptionalHash
        case someDecimal
        case someOptionalDecimal
        case customProperty
        case customOptionalProperty
        case customArray
        case customOptionalArray
    }
}
