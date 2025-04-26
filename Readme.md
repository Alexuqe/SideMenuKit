# SideMenuKit

A lightweight and highly customizable side menu implementation for iOS 15+. SideMenuKit provides an elegant solution for implementing side menu navigation with smooth animations and extensive customization options.

## Features

- **Smooth Animations**: Spring-based animations with customizable parameters
- **Blur Effect Support**: Optional background blur effect with customizable style
- **Flexible Configuration**: Extensive customization options for menu appearance and behavior
- **Custom Cell Support**: Use default cells or implement your own
- **Safe Area Aware**: Properly handles safe areas and device orientations
- **iOS 15+ Support**: Built for modern iOS applications

## Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SideMenuKit.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. Go to File > Add Packages
2. Enter the package URL
3. Click "Add Package"

## Usage

### Basic Implementation

1. Create menu items:

```swift
let menuItems: [SideMenuItemProtocol] = [
    MenuItem(title: "Home", icon: UIImage(systemName: "house"), viewController: HomeViewController()),
    MenuItem(title: "Profile", icon: UIImage(systemName: "person"), viewController: ProfileViewController()),
    MenuItem(title: "Settings", icon: UIImage(systemName: "gear"), viewController: SettingsViewController())
]
```

2. Configure and initialize the side menu:

```swift
let config = SideMenuConfiguration(
    menuWidth: 300,
    menuYOffset: 100,
    menuScaleFactor: 0.8,
    backgroundColor: .systemBackground,
    blurStyle: .regular
)

let sideMenuController = SideMenuContainerViewController(
    items: menuItems,
    configuration: config,
    homeViewController: HomeViewController()
)
```

### Animation Customization

You can fine-tune the menu animation by adjusting the configuration parameters:

```swift
// Create configuration with custom animation parameters
let config = SideMenuConfiguration(
    menuWidth: UIScreen.main.bounds.width * 0.8,    // 80% of screen width
    menuYOffset: 120,                               // Larger vertical offset
    menuScaleFactor: 0.7,                          // More pronounced scaling effect
    animationDuration: 0.6,                         // Slower animation
    springDamping: 0.65,                           // More bouncy animation
    initialSpringVelocity: 0.5,                    // Initial velocity for spring
    backgroundColor: .systemIndigo,                 // Custom background color
    blurStyle: .prominent,                         // More prominent blur
    cornerRadius: 30                               // Rounded corners
)

// Initialize menu with custom animation configuration
let sideMenuController = SideMenuContainerViewController(
    items: menuItems,
    configuration: config,
    homeViewController: HomeViewController()
)
```

### Detailed Custom Cell Implementation

Here's a complete example of a custom cell with icon, title, and selection state handling:

```swift
class CustomMenuCell: UITableViewCell, SideMenuCellProtocol {
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Container constraints
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // MARK: - SideMenuCellProtocol Implementation
    func configure(with item: SideMenuItemProtocol) {
        // Configure icon
        iconImageView.image = item.icon
        iconImageView.tintColor = item.iconColor ?? .white
        if let iconSize = item.iconSize {
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        }
        
        // Configure title
        if let attributedTitle = item.attributedTitle {
            titleLabel.attributedText = NSAttributedString(string: item.title, attributes: attributedTitle)
        } else {
            titleLabel.text = item.title
            titleLabel.font = item.titleFont ?? .systemFont(ofSize: 16, weight: .medium)
            titleLabel.textColor = .white
        }
        
        // Configure colors and appearance
        containerView.backgroundColor = item.cellBackgroundColor ?? .clear
        containerView.layer.cornerRadius = item.cellCornerRadius ?? 12
        
        // Configure selection state
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = item.selectedBackGroundColor ?? .white.withAlphaComponent(0.2)
        selectedBackgroundView = selectedBgView
    }
    
    // MARK: - Selection State
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = selected ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
        }
    }
}

// Usage example:
let config = SideMenuConfiguration()
let sideMenuController = SideMenuContainerViewController(
    items: menuItems,
    configuration: config,
    cellType: CustomMenuCell.self,    // Use our custom cell
    homeViewController: HomeViewController()
)
```

This custom cell implementation includes:
- Custom layout with container view
- Icon and title with customizable properties
- Selection state animation
- Support for all SideMenuItemProtocol properties
- Proper Auto Layout constraints
- Clean separation of concerns

## Configuration Options

### SideMenuConfiguration

```swift
SideMenuConfiguration(
    menuWidth: CGFloat,              // Width of the side menu
    menuYOffset: CGFloat,            // Vertical offset when menu is open
    menuScaleFactor: CGFloat,        // Scale factor for main view when menu is open
    animationDuration: TimeInterval, // Duration of open/close animation
    springDamping: CGFloat,         // Spring animation damping
    backgroundColor: UIColor?,      // Background color of the menu
    blurStyle: UIBlurEffect.Style?, // Optional blur effect style
    cornerRadius: CGFloat           // Corner radius when menu is open
)
```

### Menu Item Properties

The `SideMenuItemProtocol` provides the following customizable properties:

- `title`: String
- `icon`: UIImage?
- `iconColor`: UIColor?
- `iconSize`: CGFloat?
- `titleFont`: UIFont?
- `attributedTitle`: [NSAttributedString.Key: Any]?
- `selectedBackGroundColor`: UIColor?
- `cellBackgroundColor`: UIColor?
- `cellCornerRadius`: CGFloat?
- `backgroundColor`: UIColor?
- `viewController`: UIViewController?

## Delegate Methods

Implement `SideMenuDelegate` to handle menu item selection:

```swift
public protocol SideMenuDelegate: AnyObject {
    func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol)
}
```

## Example Project

Here's a complete example of implementing SideMenuKit:

```swift
import UIKit
import SideMenuKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create menu items
        let menuItems: [SideMenuItemProtocol] = [
            MenuItem(
                title: "Home",
                icon: UIImage(systemName: "house"),
                viewController: HomeViewController()
            ),
            MenuItem(
                title: "Profile",
                icon: UIImage(systemName: "person"),
                viewController: ProfileViewController()
            )
        ]
        
        // Configure the menu
        let config = SideMenuConfiguration(
            menuWidth: UIScreen.main.bounds.width * 0.7,
            menuYOffset: 100,
            menuScaleFactor: 0.8,
            backgroundColor: .systemBackground,
            blurStyle: .regular
        )
        
        // Create the side menu controller
        let sideMenuController = SideMenuContainerViewController(
            items: menuItems,
            configuration: config,
            homeViewController: HomeViewController()
        )
        
        // Present the side menu controller
        addChild(sideMenuController)
        view.addSubview(sideMenuController.view)
        sideMenuController.didMove(toParent: self)
    }
}
```

## Best Practices

1. **Memory Management**: The library uses weak references where appropriate to prevent retain cycles.
2. **Safe Area Handling**: The menu respects safe areas for proper layout on all devices.
3. **Animation Performance**: Animations are optimized for smooth performance.
4. **State Management**: The menu properly handles state changes and view controller lifecycle.

## License

SideMenuKit is available under the MIT license. See the LICENSE file for more info.
