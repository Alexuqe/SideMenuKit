import UIKit

@MainActor
public protocol SideMenuRouterProtocol {
    func navigate(to index: Int)
}

@MainActor
public final class SideMenuRouter: SideMenuRouterProtocol {
    private weak var container: UIViewController?
    private var controllers: [UIViewController]

    public init(container: UIViewController, controllers: [UIViewController]) {
        self.container = container
        self.controllers = controllers
    }

    public func navigate(to index: Int) {
        guard let containerVC = container, index < controllers.count else { return }

        resetHome(in: containerVC)

        let newController = controllers[index]

        containerVC.addChild(newController)
        containerVC.view.addSubview(newController.view)
        newController.view.frame = containerVC.view.bounds
        newController.didMove(toParent: containerVC)
    }

    private func resetHome(in containerVC: UIViewController) {
        for child in containerVC.children {
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
