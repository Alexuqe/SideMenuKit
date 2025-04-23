import UIKit

/// Менеджер для отображения/скрытия бокового меню с расширенной анимацией.
/// Все операции выполняются в главном акторе.
@MainActor
public final class SideMenuManager {

    /// Контейнерный контроллер, в который добавляется боковое меню.
    private weak var container: UIViewController?

    /// Контроллер бокового меню.
    private let sideMenuVC: SideMenuViewController

    /// Ширина бокового меню.
    private let menuWidth: CGFloat
    /// Дополнительный вертикальный сдвиг для анимации (например, 15% высоты экрана).
    private let menuHeight: CGFloat = UIScreen.main.bounds.height * 0.15

    /// Навигационный контроллер, который анимируется при открытии меню.
    private var navigationVC: UINavigationController?

    /// Blur effect view, используемый для затемнения или размытия фона.
    private var blurEffectView: UIVisualEffectView?

    /// Инициализатор менеджера.
    ///
    /// - Parameters:
    ///   - container: Контейнерный UIViewController, в который будет добавлено боковое меню.
    ///   - navigationVC: Навигационный контроллер, который будет анимироваться.
    ///   - blurEffectView: Blur effect view, на который накладывается эффект при открытии меню.
    ///   - menuWidth: Ширина бокового меню, по умолчанию 40% от ширины экрана.
    ///   - menuItems: Массив данных типа `SideMenuItem` для пункта меню.
    public init(container: UIViewController,
                navigationVC: UINavigationController?,
                blurEffectView: UIVisualEffectView?,
                menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4,
                menuItems: [SideMenuItem]) {
        self.container = container
        self.sideMenuVC = SideMenuViewController(menuWidth: menuWidth, menuItems: menuItems)
        self.menuWidth = menuWidth
        self.navigationVC = navigationVC
        self.blurEffectView = blurEffectView
    }

    /// Показывает боковое меню с комбинированной анимацией, включающей масштабирование и перенос навигационного экрана, а также изменение прозрачности blur‑view.
    ///
    /// - Parameter completion: Опциональный блок, вызываемый после завершения анимации.
    public func showMenu(completion: (() -> Void)? = nil) {
        guard let container = container else { return }

        // Добавляем SideMenuViewController в контейнер.
        container.addChild(self.sideMenuVC)
        container.view.addSubview(self.sideMenuVC.view)
        // Располагаем меню за пределами экрана слева.
        self.sideMenuVC.view.frame = CGRect(x: -menuWidth,
                                            y: 0,
                                            width: menuWidth,
                                            height: container.view.bounds.height)

        // Параметры анимации: масштабируем до 0.9, перемещаем на menuWidth по X и menuHeight по Y.
        let scaleFactor: CGFloat = 0.9
        let translationX = menuWidth
        let translationY = menuHeight

        let scaleTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let translationTransform = CGAffineTransform(translationX: translationX, y: translationY)
        let combinedTransform = translationTransform.concatenating(scaleTransform)

        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0) { [weak self] in
            guard let self = self else { return }

            // Обновляем раскладку представлений.
            self.container?.view.layoutIfNeeded()
            // Применяем скругление углов.
            self.navigationVC?.view.layer.cornerRadius = 12
            // Применяем комбинированное преобразование к навигационному контроллеру.
            self.navigationVC?.view.transform = combinedTransform
            // Устанавливаем blur-эффект.
            self.blurEffectView?.alpha = 0.9
        } completion: { _ in
            DispatchQueue.main.async {
                completion?()
            }
        }
    }

    /// Скрывает боковое меню и восстанавливает исходное состояние навигационного экрана.
    ///
    /// - Parameter completion: Опциональный блок, вызываемый после завершения анимации.
    public func hideMenu(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0) { [weak self] in
            guard let self = self else { return }

            self.container?.view.layoutIfNeeded()
            self.navigationVC?.view.layer.cornerRadius = 0
            // Возвращаем идентичное преобразование.
            self.navigationVC?.view.transform = .identity
            self.blurEffectView?.alpha = 0.0
        } completion: { [weak self] _ in
            guard let self = self else { return }
            // Удаляем SideMenuViewController из контейнера.
            self.sideMenuVC.view.removeFromSuperview()
            self.sideMenuVC.removeFromParent()
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
