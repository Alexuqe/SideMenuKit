import UIKit

public final class DefaultReplacementNavigator: SideMenuNavigator {
    public let viewControllers: [UIViewController]
    private weak var container: UIViewController?

    public init(container: UIViewController, viewControllers: [UIViewController]) {
        self.container = container
        self.viewControllers = viewControllers
    }

    public func navigateTo(index: Int) {
        guard let container = container, index < viewControllers.count else { return }

        container.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        let vc = viewControllers[index]
        container.addChild(vc)
        container.view.addSubview(vc.view)
        vc.view.frame = container.view.bounds
        vc.didMove(toParent: container)
    }
}
