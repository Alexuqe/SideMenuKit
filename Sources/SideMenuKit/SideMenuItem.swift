import UIKit

    /// Модель данных для пункта бокового меню.
    /// Каждый объект содержит заголовок и опциональное изображение.
public struct SideMenuItem {
        /// Заголовок пункта меню.
    public let title: String
        /// Изображение пункта меню (опционально).
    public let image: UIImage?
        /// Подзаголовок пункта меню.
    public let subtitle: String?

        /// Инициализатор для создания пункта меню.
        ///
        /// - Parameters:
        ///   - title: Заголовок пункта меню.
        ///   - image: Изображение для пункта меню (по умолчанию `nil`).
        ///   - subtitle: Подзаголовок пункта меню
    public init(title: String, image: UIImage? = nil, subtitle: String) {
        self.title = title
        self.image = image
        self.subtitle = subtitle
    }
}
