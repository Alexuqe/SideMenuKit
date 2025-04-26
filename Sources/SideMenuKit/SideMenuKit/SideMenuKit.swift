import UIKit

public final class SideMenuKit {
    public static func create(
        items: [SideMenuItemProtocol],
        configuration: SideMenuConfiguration = .init(),
        cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self,
        homeViewController: UIViewController
    ) -> UIViewController {
        return SideMenuContainerViewController(
            items: items,
            configuration: configuration,
            cellType: cellType,
            homeViewController: homeViewController
        )
    }
}
