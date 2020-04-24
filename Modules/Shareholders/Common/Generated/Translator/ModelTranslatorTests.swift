//
// ModelTranslator Tests
// Generated on 24/04/2020 by gen v0.3.4
//

import AlfaFoundation
import Nimble
import Quick

@testable import Shareholders

final class ModelTranslatorTests: QuickSpec {
    override func spec() {
        var translator: ModelTranslator!

        beforeEach {
            translator = ModelTranslator()
        }

        describe(".translateFromDictionary") {
            it("should throw error for invalid DTO") {
                expect {
                    try translator.translateFrom(dictionary: TestData.emptyDTO)
                }.to(throwError())
            }
            it("should return data model for valid DTO") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTO)
                }.to(equal(TestData.validModel))
            }
            it("should return data model for valid DTO without optUrl") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTOWithoutOptUrl)
                }.to(equal(TestData.validModelWithoutOptUrl))
            }
            it("should return data model for valid DTO without someOptionalHash") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTOWithoutSomeOptionalHash)
                }.to(equal(TestData.validModelWithoutSomeOptionalHash))
            }
            it("should return data model for valid DTO without someOptionalDecimal") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTOWithoutSomeOptionalDecimal)
                }.to(equal(TestData.validModelWithoutSomeOptionalDecimal))
            }
            it("should return data model for valid DTO without customOptionalProperty") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTOWithoutCustomOptionalProperty)
                }.to(equal(TestData.validModelWithoutCustomOptionalProperty))
            }
            it("should return data model for valid DTO without customOptionalArray") {
                expect {
                    try translator.translateFrom(dictionary: TestData.validDTOWithoutCustomOptionalArray)
                }.to(equal(TestData.validModelWithoutCustomOptionalArray))
            }
        }

        describe(".translateToDictionary") {
            it("should return valid DTO") {
                // when
                let dictionary = translator.translateToDictionary(TestData.validModel)
                // then
                expect {
                    try translator.translateFrom(dictionary: dictionary)
                }.to(equal(TestData.validModel))
            }
        }
    }
}

extension ModelTranslatorTests {
    enum TestData {
        static let keys = ModelTranslator.DTOKeys.self
        static let emptyDTO: [String: Any] = [:]
        static let validModel = Model.Seeds.value
        static let validDTO: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.customProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customProperty),
            keys.customOptionalProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customOptionalProperty),
            keys.customArray.rawValue: AmountTranslator().translateToArray(validModel.customArray),
            keys.customOptionalArray.rawValue: AmountTranslator().translateToArray(validModel.customOptionalArray),
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normURL.rawValue: validModel.normURL.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutOptUrl = Model(
            optUrl: nil,
            normURL: validModel.normURL,
            someHash: validModel.someHash,
            someOptionalHash: validModel.someOptionalHash,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: validModel.someOptionalDecimal,
            customProperty: validModel.customProperty,
            customOptionalProperty: validModel.customOptionalProperty,
            customArray: validModel.customArray,
            customOptionalArray: validModel.customOptionalArray
        )
        static let validDTOWithoutOptUrl: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.customProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customProperty),
            keys.customOptionalProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customOptionalProperty),
            keys.customArray.rawValue: AmountTranslator().translateToArray(validModel.customArray),
            keys.customOptionalArray.rawValue: AmountTranslator().translateToArray(validModel.customOptionalArray),
            keys.normURL.rawValue: validModel.normURL.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutSomeOptionalHash = Model(
            optUrl: validModel.optUrl,
            normURL: validModel.normURL,
            someHash: validModel.someHash,
            someOptionalHash: nil,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: validModel.someOptionalDecimal,
            customProperty: validModel.customProperty,
            customOptionalProperty: validModel.customOptionalProperty,
            customArray: validModel.customArray,
            customOptionalArray: validModel.customOptionalArray
        )
        static let validDTOWithoutSomeOptionalHash: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.customProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customProperty),
            keys.customOptionalProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customOptionalProperty),
            keys.customArray.rawValue: AmountTranslator().translateToArray(validModel.customArray),
            keys.customOptionalArray.rawValue: AmountTranslator().translateToArray(validModel.customOptionalArray),
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normURL.rawValue: validModel.normURL.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutSomeOptionalDecimal = Model(
            optUrl: validModel.optUrl,
            normURL: validModel.normURL,
            someHash: validModel.someHash,
            someOptionalHash: validModel.someOptionalHash,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: nil,
            customProperty: validModel.customProperty,
            customOptionalProperty: validModel.customOptionalProperty,
            customArray: validModel.customArray,
            customOptionalArray: validModel.customOptionalArray
        )
        static let validDTOWithoutSomeOptionalDecimal: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.customProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customProperty),
            keys.customOptionalProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customOptionalProperty),
            keys.customArray.rawValue: AmountTranslator().translateToArray(validModel.customArray),
            keys.customOptionalArray.rawValue: AmountTranslator().translateToArray(validModel.customOptionalArray),
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normURL.rawValue: validModel.normURL.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
        ]
        static let validModelWithoutCustomOptionalProperty = Model(
            optUrl: validModel.optUrl,
            normURL: validModel.normURL,
            someHash: validModel.someHash,
            someOptionalHash: validModel.someOptionalHash,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: validModel.someOptionalDecimal,
            customProperty: validModel.customProperty,
            customOptionalProperty: nil,
            customArray: validModel.customArray,
            customOptionalArray: validModel.customOptionalArray
        )
        static let validDTOWithoutCustomOptionalProperty: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.customProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customProperty),
            keys.customArray.rawValue: AmountTranslator().translateToArray(validModel.customArray),
            keys.customOptionalArray.rawValue: AmountTranslator().translateToArray(validModel.customOptionalArray),
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normURL.rawValue: validModel.normURL.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutCustomOptionalArray = Model(
            optUrl: validModel.optUrl,
            normURL: validModel.normURL,
            someHash: validModel.someHash,
            someOptionalHash: validModel.someOptionalHash,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: validModel.someOptionalDecimal,
            customProperty: validModel.customProperty,
            customOptionalProperty: validModel.customOptionalProperty,
            customArray: validModel.customArray,
            customOptionalArray: nil
        )
        static let validDTOWithoutCustomOptionalArray: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.customProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customProperty),
            keys.customOptionalProperty.rawValue: AmountTranslator().translateToDictionary(from: validModel.customOptionalProperty),
            keys.customArray.rawValue: AmountTranslator().translateToArray(validModel.customArray),
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normURL.rawValue: validModel.normURL.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
    }
}
