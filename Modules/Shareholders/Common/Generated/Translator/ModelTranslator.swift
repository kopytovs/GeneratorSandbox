//
// Model Translator
// Generated on 13/03/2020 by gen v0.3
//

import AlfaFoundation

struct ModelTranslator: Translator {
    func translateFrom(dictionary json: [String: Any]) throws -> Model {
        let someHash: [String: Any] = try json.get(DTOKeys.someHash)
        let someOptionalHash: [String: Any]? = try? json.get(DTOKeys.someOptionalHash)
        let optUrl = URL(string: (try? json.get(DTOKeys.optUrl)) ?? "")
        guard let normUrl = URL(string: try json.get(DTOKeys.normUrl)) else {
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
            normUrl: normUrl,
            someHash: someHash,
            someOptionalHash: someOptionalHash,
            someDecimal: someDecimal,
            someOptionalDecimal: someOptionalDecimal
        )
    }

    func translateToDictionary(_ object: Model) -> [String: Any] {
        return fromDTO(
            DTOKeys.self,
            [
                .someHash: object.someHash,
                .someOptionalHash: object.someOptionalHash as Any,
                .optUrl: object.optUrl?.absoluteString as Any,
                .normUrl: object.normUrl.absoluteString,
                .someDecimal: (object.someDecimal as NSDecimalNumber).doubleValue,
                .someOptionalDecimal: (object.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
            ]
        )
    }
}

extension ModelTranslator {
    enum DTOKeys: String {
        case optUrl
        case normUrl
        case someHash
        case someOptionalHash
        case someDecimal
        case someOptionalDecimal
    }
}
