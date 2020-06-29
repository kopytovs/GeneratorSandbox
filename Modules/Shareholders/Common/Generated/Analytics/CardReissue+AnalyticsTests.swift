//
// SUT: CardReissueAnalytics
//

import AlfaNetworking
import Nimble
import Quick
import TestAdditions

@testable import CardReissue

// swiftlint:disable function_body_length

final class CardReissueAnalyticsTests: QuickSpec {
    override func spec() {
        var analytics: CardReissueAnalytics!
        var facadeMock: AnalyticsFacadeMock!

        beforeEach {
            facadeMock = .init()
            analytics = .init(analyticsFacade: facadeMock)
        }

        describe(".trackChooseOfficeClick") {
            it("should track event") {
                // when
                analytics.trackChooseOfficeClick()
                // then
                expect(facadeMock.trackCategoryActionLabelValuePropertyScreenDimensionsWasCalled).to(beCalledOnce())
                expect(facadeMock.trackEventArguments?.event).to(equal(TestData.category))
                expect(facadeMock.trackEventArguments?.screen).to(equal(TestData.trackChooseOfficeClickScreen))
                expect(facadeMock.trackEventArguments?.action).to(equal(TestData.trackChooseOfficeClickAction))
                expect(facadeMock.trackEventArguments?.label).to(equal(TestData.trackChooseOfficeClickLabel))
                expect(facadeMock.trackEventArguments?.property).to(beNil())
                expect(facadeMock.trackEventArguments?.value).to(equal(0))
            }
        }

        describe(".trackReissueReasonSelect") {
            it("should track event") {
                // when
                analytics.trackReissueReasonSelect(reasonID: TestData.trackReissueReasonSelect_reasonID)
                // then
                expect(facadeMock.trackCategoryActionLabelValuePropertyScreenDimensionsWasCalled).to(beCalledOnce())
                expect(facadeMock.trackEventArguments?.event).to(equal(TestData.category))
                expect(facadeMock.trackEventArguments?.screen).to(equal(TestData.trackReissueReasonSelectScreen))
                expect(facadeMock.trackEventArguments?.action).to(equal(TestData.trackReissueReasonSelectAction))
                expect(facadeMock.trackEventArguments?.label).to(equal(TestData.trackReissueReasonSelectLabel))
                expect(facadeMock.trackEventArguments?.property).to(equal(TestData.trackReissueReasonSelect_reasonID))
                expect(facadeMock.trackEventArguments?.value).to(equal(0))
            }
        }

    }
}

private extension CardReissueAnalyticsTests {
    enum TestData {
        static let category = "Card Reissuing"

        static let trackChooseOfficeClickScreen = "Card Reissue"
        static let trackChooseOfficeClickAction = "Click"
        static let trackChooseOfficeClickLabel = "Choose Office"
        

        static let trackReissueReasonSelectScreen = "Card Reissue"
        static let trackReissueReasonSelectAction = "Select"
        static let trackReissueReasonSelectLabel = "Reissue Reason"
        static let trackReissueReasonSelect_reasonID = String

    }
}

