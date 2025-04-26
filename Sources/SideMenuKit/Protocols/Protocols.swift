import UIKit

public protocol SideMenuItemProtocol {
    var title: String { get }
    var icon: UIImage? { get }
    var viewController: UIViewController? { get }
}

public protocol SideMenuCellProtocol: UITableViewCell {
    static var reuseIdentifier: String { get }
    func configure(with item: SideMenuItemProtocol)
}

public extension SideMenuCellProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol SideMenuDelegate: AnyObject {
    func sideMenu(
        _ sideMenu: SideMenuViewController,
        didSelectItem item: SideMenuItemProtocol
    )
}

protocol SideMenuAnimatorProtocol {
    func animate(
        view: UIView,
        isOpen: Bool,
        configuration: SideMenuConfiguration,
        blurView: UIVisualEffectView?,
        completion: (() -> Void)?
    )
}
