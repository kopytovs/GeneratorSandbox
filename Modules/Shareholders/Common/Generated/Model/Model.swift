//
// Model Model
// Generated on 24/04/2020 by gen v0.3.4
//

import AlfaFoundation

/// Test
struct Model: Equatable {
    /// Опциональный урл
    let optUrl: URL?
    /// Не опциональный урл
    let normURL: URL
    /// Какой-то хэш
    let someHash: [String: Any]
    /// Какой-то опциональный хэш
    let someOptionalHash: [String: Any]?
    /// Какой-то десимал
    let someDecimal: Decimal
    /// Какой-то опциональный десимал
    let someOptionalDecimal: Decimal?
    /// Какая-то кастомная пропертя
    let customProperty: Amount
    /// Какая-то кастомная и опциональная пропертя
    let customOptionalProperty: Amount?
    /// Массив каких-то кастомных пропертей
    let customArray: [Amount]
    /// Опциональный массив каких-то кастомных пропертей
    let customOptionalArray: [Amount]?
}
