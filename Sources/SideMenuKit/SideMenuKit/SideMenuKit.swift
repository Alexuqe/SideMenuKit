import UIKit

public final class SideMenuKit {
    public static func create(
        items: [SideMenuItemProtocol],
        configuration: SideMenuConfiguration = .init(),
        cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self,
        navigationController: UINavigationController
    ) -> UIViewController {
        let containerViewController = SideMenuContainerViewController(
            items: items,
            configuration: configuration,
            cellType: cellType,
            navigationController: navigationController
        )
        
        // Add container view controller to navigation controller
        navigationController.view.addSubview(containerViewController.view)
        containerViewController.view.frame = navigationController.view.bounds
        containerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        navigationController.addChild(containerViewController)
        containerViewController.didMove(toParent: navigationController)
        
        return navigationController
    }
}
