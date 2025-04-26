import UIKit

public protocol SideMenuItemProtocol {
    var title: String { get }
    var icon: UIImage? { get }
    var iconColor: UIColor? { get }
    var iconSize: CGFloat? { get }
    var titleFont: UIFont? { get }

    var attributedTitle: [NSAttributedString.Key : Any]? { get }
    var selectedBackGroundColor: UIColor? { get }
    var cellBackgroundColor: UIColor? { get }
    var cellCornerRadius: CGFloat? { get }

    var backgroundColor: UIColor? { get }
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
    func sideMenu(_ sideMenu: SideMenuViewController,
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
