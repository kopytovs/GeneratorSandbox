//
// Model Model
// Generated on 13/03/2020 by gen v0.3
//

import AlfaFoundation

/// Test
struct Model: Equatable {
    /// Опциональный урл
    let optUrl: URL?
    /// Не опциональный урл
    let normUrl: URL
    /// Какой-то хэш
    let someHash: [String: Any]
    /// Какой-то опциональный хэш
    let someOptionalHash: [String: Any]?
    /// Какой-то десимал
    let someDecimal: Decimal
    /// Какой-то опциональный десимал
    let someOptionalDecimal: Decimal?
}
