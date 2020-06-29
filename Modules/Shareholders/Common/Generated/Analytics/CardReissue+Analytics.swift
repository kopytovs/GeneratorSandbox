//
// CardReissue Analytics
//

import AlfaFoundation

protocol CardReissueEvents: AnyObject {
    func trackChooseOfficeClick()
    func trackReissueReasonSelect(reasonID: String)
}

final class CardReissueAnalytics: CardReissueEvents {

    private enum Configuration {
        static let category = "Card Reissuing"
    }

    let analyticsFacade: AnalyticsFacadeProtocol

    init(analyticsFacade: AnalyticsFacadeProtocol) {
        self.analyticsFacade = analyticsFacade
    }

        /// Нажатие на выбор офиса
        func trackChooseOfficeClick() {
            analyticsFacade.track(
                category: Configuration.category,
                action: "Click",
                label: "Choose Office",
                value: 0,
                property: nil,
                screen: "Card Reissue",
                dimensions: nil
            )
        }
        /// Нажатие на выбор причины
        func trackReissueReasonSelect(reasonID: String) {
            analyticsFacade.track(
                category: Configuration.category,
                action: "Select",
                label: "Reissue Reason",
                value: 0,
                property: reasonID,
                screen: "Card Reissue",
                dimensions: nil
            )
        }
}

