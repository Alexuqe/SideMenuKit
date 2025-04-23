import UIKit

/// Класс для управления показом и скрытием бокового меню.
/// Все операции выполняются в главном UI-контексте.
@MainActor
public final class SideMenuManager {

    /// Контейнер, в который добавляется боковое меню.
    private weak var container: UIViewController?

    /// Экземпляр бокового меню.
    private let sideMenuVC: SideMenuViewController

    /// Ширина бокового меню.
    private let menuWidth: CGFloat

    /// Инициализирует менеджер меню.
    ///
    /// - Parameters:
    ///   - container: Контейнерный UIViewController, в котором будет отображаться меню.
    ///   - menuWidth: Ширина меню. По умолчанию – 40% ширины экрана.
    ///   - menuItems: Массив объектов `SideMenuItem`, описывающих пункты меню.
    public init(container: UIViewController, menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4, menuItems: [SideMenuItem]) {
        self.container = container
        self.sideMenuVC = SideMenuViewController(menuWidth: menuWidth, menuItems: menuItems)
        self.menuWidth = menuWidth
    }

    /// Показывает меню с анимированным входом.
    public func showMenu() {
        guard let container = container else { return }

        DispatchQueue.main.async {
            container.addChild(self.sideMenuVC)
            container.view.addSubview(self.sideMenuVC.view)

            // Устанавливаем начальное положение меню за пределами экрана.
            self.sideMenuVC.view.frame = CGRect(x: -self.menuWidth, y: 0, width: self.menuWidth, height: container.view.bounds.height)

            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0) {
                // Анимируем появление меню, сдвигая его в нулевую позицию по оси X.
                self.sideMenuVC.view.frame.origin.x = 0
            }
        }
    }

    /// Скрывает меню с анимацией.
    public func hideMenu() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0) {
                // Сдвигаем меню за пределы экрана
                self.sideMenuVC.view.frame.origin.x = -self.menuWidth
            } completion: { _ in
                // Удаляем меню из иерархии после завершения анимации.
                self.sideMenuVC.view.removeFromSuperview()
                self.sideMenuVC.removeFromParent()
            }
        }
    }
}
