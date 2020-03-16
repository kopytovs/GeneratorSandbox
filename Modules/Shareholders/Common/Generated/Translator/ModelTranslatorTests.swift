//
// ModelTranslator Tests
// Generated on 13/03/2020 by gen v0.3
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
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normUrl.rawValue: validModel.normUrl.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutOptUrl = Model(
            optUrl: nil,
            normUrl: validModel.normUrl,
            someHash: validModel.someHash,
            someOptionalHash: validModel.someOptionalHash,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: validModel.someOptionalDecimal
        )
        static let validDTOWithoutOptUrl: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.normUrl.rawValue: validModel.normUrl.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutSomeOptionalHash = Model(
            optUrl: validModel.optUrl,
            normUrl: validModel.normUrl,
            someHash: validModel.someHash,
            someOptionalHash: nil,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: validModel.someOptionalDecimal
        )
        static let validDTOWithoutSomeOptionalHash: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normUrl.rawValue: validModel.normUrl.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
            keys.someOptionalDecimal.rawValue: (validModel.someOptionalDecimal as NSDecimalNumber?)?.doubleValue as Any,
        ]
        static let validModelWithoutSomeOptionalDecimal = Model(
            optUrl: validModel.optUrl,
            normUrl: validModel.normUrl,
            someHash: validModel.someHash,
            someOptionalHash: validModel.someOptionalHash,
            someDecimal: validModel.someDecimal,
            someOptionalDecimal: nil
        )
        static let validDTOWithoutSomeOptionalDecimal: [String: Any] = [
            keys.someHash.rawValue: validModel.someHash,
            keys.someOptionalHash.rawValue: validModel.someOptionalHash as Any,
            keys.optUrl.rawValue: validModel.optUrl?.absoluteString as Any,
            keys.normUrl.rawValue: validModel.normUrl.absoluteString,
            keys.someDecimal.rawValue: (validModel.someDecimal as NSDecimalNumber).doubleValue,
        ]
    }
}
