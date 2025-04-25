import UIKit

public extension UIViewController {
    func attachSideMenu(
        configuration: SideMenuConfiguration,
        viewControllers: [UIViewController]
    ) -> SideMenuController {
        let controller = SideMenuController(
            configuration: configuration,
            contentViewController: self,
            containerView: view
        )
        controller.setDefaultNavigation(viewControllers: viewControllers)
        return controller
    }
}
