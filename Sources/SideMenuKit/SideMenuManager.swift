import UIKit

@MainActor
public final class SideMenuManager {

    private weak var container: UIViewController?
    private let sideMenuVC: SideMenuViewController
    private let menuWidth: CGFloat

    public init(container: UIViewController, menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4, menuItems: [SideMenuItem]) {
        self.container = container
        self.sideMenuVC = SideMenuViewController(menuWidth: menuWidth, menuItems: menuItems)
        self.menuWidth = menuWidth
    }

    public func showMenu() {
        guard let container = container else { return }

        DispatchQueue.main.async {
            container.addChild(self.sideMenuVC)
            container.view.addSubview(self.sideMenuVC.view)
            self.sideMenuVC.view.frame = CGRect(x: -self.menuWidth, y: 0, width: self.menuWidth, height: container.view.bounds.height)
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0) {
                self.sideMenuVC.view.frame.origin.x = 0
            }
        }
    }

    public func hideMenu() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0) {
                self.sideMenuVC.view.frame.origin.x = -self.menuWidth
            } completion: { _ in
                self.sideMenuVC.view.removeFromSuperview()
                self.sideMenuVC.removeFromParent()
            }
        }
    }
}
