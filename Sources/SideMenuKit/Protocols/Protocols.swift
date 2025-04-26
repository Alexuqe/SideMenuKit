import UIKit

/// A protocol that defines the properties of a menu item in the side menu.
///
/// Implement this protocol to create custom menu items with configurable appearance and behavior.
/// Each menu item can have its own visual style and associated view controller.
///
/// Example implementation:
/// ```swift
/// struct MenuItem: SideMenuItemProtocol {
///     let title: String
///     let icon: UIImage?
///     let viewController: UIViewController?
/// }
/// ```
public protocol SideMenuItemProtocol {
    /// The title text to display in the menu item.
    var title: String { get }
    
    /// An optional icon to display alongside the title.
    /// - Note: If nil, only the title will be displayed.
    var icon: UIImage? { get }
    
    /// The color to apply to the icon.
    /// - Note: If nil, the default tint color will be used.
    var iconColor: UIColor? { get }
    
    /// The size of the icon in points.
    /// - Note: If nil, the default system size will be used.
    var iconSize: CGFloat? { get }
    
    /// The font to use for the title text.
    /// - Note: If nil, the default system font will be used.
    var titleFont: UIFont? { get }

    /// Attributed string attributes to apply to the title.
    /// - Note: If provided, these attributes will override the titleFont property.
    var attributedTitle: [NSAttributedString.Key : Any]? { get }
    
    /// The background color to use when the item is selected.
    /// - Note: If nil, a default selection color will be used.
    var selectedBackGroundColor: UIColor? { get }
    
    /// The background color of the cell.
    /// - Note: If nil, the cell will be transparent.
    var cellBackgroundColor: UIColor? { get }
    
    /// The corner radius of the cell.
    /// - Note: If nil, the default corner radius will be used.
    var cellCornerRadius: CGFloat? { get }

    /// The background color of the item.
    /// - Note: This differs from cellBackgroundColor as it applies to the item's container.
    var backgroundColor: UIColor? { get }
    
    /// The view controller associated with this menu item.
    /// - Note: When the item is selected, this view controller will be displayed.
    var viewController: UIViewController? { get }
}

/// A protocol that defines the requirements for a custom menu cell.
///
/// Implement this protocol to create custom cells for the side menu.
/// The cell must be a subclass of UITableViewCell and provide configuration
/// capabilities for menu items.
///
/// Example implementation:
/// ```swift
/// class CustomCell: UITableViewCell, SideMenuCellProtocol {
///     static var reuseIdentifier: String { "CustomCell" }
///     
///     func configure(with item: SideMenuItemProtocol) {
///         // Configure cell appearance
///     }
/// }
/// ```
public protocol SideMenuCellProtocol: UITableViewCell {
    /// The reuse identifier for the cell.
    /// - Note: This is used for cell registration and dequeuing.
    static var reuseIdentifier: String { get }
    
    /// Configures the cell with the provided menu item.
    /// - Parameter item: The menu item to configure the cell with.
    func configure(with item: SideMenuItemProtocol)
}

/// Default implementation of reuseIdentifier that returns the class name.
public extension SideMenuCellProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

/// A protocol that defines the delegate methods for the side menu.
///
/// Implement this protocol to handle menu item selection events.
/// The delegate is responsible for responding to user interactions with the menu.
///
/// Example implementation:
/// ```swift
/// class ViewController: UIViewController, SideMenuDelegate {
///     func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol) {
///         // Handle item selection
///     }
/// }
/// ```
public protocol SideMenuDelegate: AnyObject {
    /// Called when a menu item is selected.
    /// - Parameters:
    ///   - sideMenu: The side menu view controller that triggered the selection.
    ///   - item: The menu item that was selected.
    func sideMenu(_ sideMenu: SideMenuViewController,
        didSelectItem item: SideMenuItemProtocol
    )
}

/// A protocol that defines the animation behavior for the side menu.
///
/// Implement this protocol to create custom animations for the menu's open and close transitions.
/// The animator is responsible for handling all visual transitions of the menu.
///
/// Example implementation:
/// ```swift
/// class CustomAnimator: SideMenuAnimatorProtocol {
///     func animate(view: UIView, isOpen: Bool, configuration: SideMenuConfiguration,
///                 blurView: UIVisualEffectView?, completion: (() -> Void)?) {
///         // Implement custom animation
///     }
/// }
/// ```
protocol SideMenuAnimatorProtocol {
    /// Animates the menu's open/close transition.
    /// - Parameters:
    ///   - view: The view to animate.
    ///   - isOpen: Whether the menu should be opened or closed.
    ///   - configuration: The configuration to use for the animation.
    ///   - blurView: An optional blur view to animate alongside the menu.
    ///   - completion: A closure to call when the animation completes.
    func animate(
        view: UIView,
        isOpen: Bool,
        configuration: SideMenuConfiguration,
        blurView: UIVisualEffectView?,
        completion: (() -> Void)?
    )
}
