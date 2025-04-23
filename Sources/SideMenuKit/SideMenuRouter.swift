import UIKit

/// Протокол роутера для навигации между экранами.
@MainActor
public protocol SideMenuRouterProtocol {
    /// Переходит к экрану по индексу из массива контроллеров.
    /// - Parameter index: Индекс экрана для отображения.
    func navigate(to index: Int)
}

/// Роутер для централизованной навигации. Принимает массив UIViewController и заменяет текущий
/// дочерний контроллер выбранным по индексу.
@MainActor
public final class SideMenuRouter: SideMenuRouterProtocol {
    /// Контейнерный UIViewController, в который добавляются контроллеры.
    private weak var container: UIViewController?

    /// Массив контроллеров для переключения между экранами.
    private var controllers: [UIViewController]

    /// Инициализатор роутера.
    ///
    /// - Parameters:
    ///   - container: Контейнерный UIViewController.
    ///   - controllers: Массив UIViewController, используемых для навигации.
    public init(container: UIViewController, controllers: [UIViewController]) {
        self.container = container
        self.controllers = controllers
    }

    /// Переходит к экрану с выбранным индексом.
    public func navigate(to index: Int) {
        guard let containerVC = container, index < controllers.count else { return }

        // Удаляем все дочерние контроллеры из контейнера.
        resetHome(in: containerVC)

        // Получаем новый контроллер и добавляем его в качестве дочернего.
        let newController = controllers[index]
        containerVC.addChild(newController)
        containerVC.view.addSubview(newController.view)
        newController.view.frame = containerVC.view.bounds
        newController.didMove(toParent: containerVC)
    }

    /// Удаляет всех дочерних контроллеров из контейнера.
    ///
    /// - Parameter containerVC: Контейнер, из которого нужно удалить дочерние контроллеры.
    private func resetHome(in containerVC: UIViewController) {
        for child in containerVC.children {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
