# ``SideMenuKit``

A lightweight and highly customizable side menu implementation for iOS applications.

## Overview

SideMenuKit provides an elegant solution for implementing side menu navigation with smooth animations and extensive customization options. The library is built with modern iOS development practices in mind and offers a flexible API for creating customized side menu experiences.

## Topics

### Essentials

- <doc:GettingStarted>
- ``SideMenuContainerViewController``
- ``SideMenuConfiguration``

### Protocols

- ``SideMenuItemProtocol``
- ``SideMenuCellProtocol``
- ``SideMenuDelegate``
- ``SideMenuAnimatorProtocol``

### View Controllers

- ``SideMenuViewController``
- ``SideMenuContainerViewController``

### Configuration

- ``SideMenuConfiguration``
- ``CellConfiguration``

### Animation

- ``SideMenuAnimator``

## Configuration Options

### Menu Configuration

```swift
public struct SideMenuConfiguration {
    /// Width of the side menu. Default is 40% of screen width.
    public let menuWidth: CGFloat
    
    /// Vertical offset when menu is open. Default is 15% of screen height.
    public let menuYOffset: CGFloat
    
    /// Scale factor for main view when menu is open. Default is 0.85.
    public let menuScaleFactor: CGFloat
    
    /// Duration of open/close animation. Default is 0.4 seconds.
    public let animationDuration: TimeInterval
    
    /// Spring animation damping. Default is 0.8.
    public let springDamping: CGFloat
    
    /// Initial spring velocity. Default is 0.
    public let initialSpringVelocity: CGFloat
    
    /// Background color of the menu. Default is nil.
    public let backgroundColor: UIColor?
    
    /// Optional blur effect style. Default is .regular.
    public let blurStyle: UIBlurEffect.Style?
    
    /// Corner radius when menu is open. Default is 40.
    public let cornerRadius: CGFloat
}
```

### Menu Item Protocol

```swift
public protocol SideMenuItemProtocol {
    /// Title of the menu item
    var title: String { get }
    
    /// Icon image for the menu item
    var icon: UIImage? { get }
    
    /// Color of the icon. Default is white.
    var iconColor: UIColor? { get }
    
    /// Size of the icon. Default is system size.
    var iconSize: CGFloat? { get }
    
    /// Font for the title. Default is system font.
    var titleFont: UIFont? { get }
    
    /// Attributed string attributes for the title
    var attributedTitle: [NSAttributedString.Key : Any]? { get }
    
    /// Background color when item is selected
    var selectedBackGroundColor: UIColor? { get }
    
    /// Background color of the cell
    var cellBackgroundColor: UIColor? { get }
    
    /// Corner radius of the cell
    var cellCornerRadius: CGFloat? { get }
    
    /// Background color of the item
    var backgroundColor: UIColor? { get }
    
    /// View controller associated with this item
    var viewController: UIViewController? { get }
}
```

### Cell Protocol

```swift
public protocol SideMenuCellProtocol: UITableViewCell {
    /// Reuse identifier for the cell
    static var reuseIdentifier: String { get }
    
    /// Configure the cell with a menu item
    func configure(with item: SideMenuItemProtocol)
}
```

### Delegate Protocol

```swift
public protocol SideMenuDelegate: AnyObject {
    /// Called when a menu item is selected
    /// - Parameters:
    ///   - sideMenu: The side menu view controller
    ///   - item: The selected menu item
    func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol)
}
```

## Usage Examples

### Basic Setup

```swift
// Create menu items
let menuItems: [SideMenuItemProtocol] = [
    MenuItem(title: "Home", icon: UIImage(systemName: "house")),
    MenuItem(title: "Profile", icon: UIImage(systemName: "person")),
    MenuItem(title: "Settings", icon: UIImage(systemName: "gear"))
]

// Configure the menu
let config = SideMenuConfiguration(
    menuWidth: 300,
    menuYOffset: 100,
    menuScaleFactor: 0.8
)

// Create and present the menu
let sideMenuController = SideMenuContainerViewController(
    items: menuItems,
    configuration: config,
    homeViewController: HomeViewController()
)
```

### Custom Cell Implementation

```swift
class CustomMenuCell: UITableViewCell, SideMenuCellProtocol {
    // Implementation details...
    
    func configure(with item: SideMenuItemProtocol) {
        // Cell configuration...
    }
}

// Usage
let sideMenuController = SideMenuContainerViewController(
    items: menuItems,
    configuration: config,
    cellType: CustomMenuCell.self,
    homeViewController: HomeViewController()
)
```

## Best Practices

### Memory Management

The library uses weak references for delegates and view controller references to prevent retain cycles. When implementing custom cells or view controllers, follow these guidelines:

- Use `weak` references for delegates
- Properly manage view controller lifecycle
- Clean up any observers or timers

### Animation Performance

To ensure smooth animations:

- Avoid heavy computations during animation
- Use appropriate animation curves
- Consider using `UIViewPropertyAnimator` for complex animations

### Safe Area Handling

The library automatically handles safe areas, but when implementing custom cells:

- Respect safe area insets
- Use layout margins appropriately
- Test on different device sizes

### State Management

To maintain proper state:

- Handle view controller lifecycle events
- Manage menu open/close states
- Handle orientation changes

## See Also

- [Swift UI Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios) 