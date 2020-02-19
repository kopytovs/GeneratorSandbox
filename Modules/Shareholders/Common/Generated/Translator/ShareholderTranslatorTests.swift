//
// ShareholderTranslator Tests
// Generated on 18/02/2020 by gen v0.2
//

import AlfaFoundation
import Nimble
import Quick
import SharedModels

@testable import Shareholders

final class ShareholderTranslatorTests: QuickSpec {
    override func spec() {
        var translator: ShareholderTranslator!

        beforeEach {
            translator = ShareholderTranslator()
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

extension ShareholderTranslatorTests {
    enum TestData {
        static let keys = ShareholderTranslator.DTOKeys.self
        static let emptyDTO: [String: Any] = [:]
        static let validModel = Shareholder.Seeds.value
        static let validDTO: [String: Any] = [
            keys.id.rawValue: validModel.uid,
            keys.iconURL.rawValue: validModel.iconURL,
            keys.name.rawValue: validModel.name,
            keys.profit.rawValue: validModel.profit,
            keys.company.rawValue: validModel.company.rawValue,
            keys.amount.rawValue: AmountTranslator().translateToDictionary(validModel.amount),
        ]
    }
}
