//
// Shareholder Model
// Generated on 30/03/2021 by gen v0.5.3
//

import AlfaFoundation
import SharedModels

/// Тип банка
enum Company: String {
    case tinkoff = "tinek"
    case sberbank = "Sber"
    case alfa = "Alfabank"
}

/// Модель держателя карты
struct Shareholder: Equatable, UniqueIdentifiable {
    /// Идентификатор акционера
    let uid: String
    /// Путь к аватарке
    let iconURL: String
    /// Имя акционера
    let name: String
    /// Название компании
    let company: Company
    /// Сумма активов
    let amount: Amount?
    /// Доходность за предыдущий год
    let profit: Double
}
