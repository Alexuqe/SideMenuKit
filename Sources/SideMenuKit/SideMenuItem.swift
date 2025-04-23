import UIKit

    /// Модель данных для пункта бокового меню.
    /// Каждый объект содержит заголовок и опциональное изображение.
public struct SideMenuItem {
        /// Заголовок пункта меню.
    public let title: String
        /// Изображение пункта меню (опционально).
    public let image: UIImage?
    
        /// Инициализатор для создания пункта меню.
        ///
        /// - Parameters:
        ///   - title: Заголовок пункта меню.
        ///   - image: Изображение для пункта меню (по умолчанию `nil`).
    public init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
