# ``SideMenuContainerViewController``

The main container view controller that manages the side menu and content area.

## Overview

`SideMenuContainerViewController` is the primary view controller that manages the side menu interface. It handles the layout and interaction between the menu and main content area, including animations and state management.

## Topics

### Creating a Container Controller

```swift
public init(
    items: [SideMenuItemProtocol],
    configuration: SideMenuConfiguration = SideMenuConfiguration(),
    cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self,
    homeViewController: UIViewController
)
```

### Example Usage

```swift
// Create menu items
let menuItems: [SideMenuItemProtocol] = [
    MenuItem(title: "Home", icon: UIImage(systemName: "house")),
    MenuItem(title: "Profile", icon: UIImage(systemName: "person"))
]

// Create configuration
let config = SideMenuConfiguration(
    menuWidth: 300,
    menuYOffset: 100,
    menuScaleFactor: 0.8
)

// Initialize container
let container = SideMenuContainerViewController(
    items: menuItems,
    configuration: config,
    homeViewController: HomeViewController()
)

// Present the container
present(container, animated: true)
```

## Features

### Menu Management
- Handles menu open/close animations
- Manages menu item selection
- Coordinates view controller transitions

### View Controller Management
- Manages the main content area
- Handles view controller transitions
- Maintains navigation stack

### Animation
- Smooth open/close transitions
- Scale and translation effects
- Optional blur effects
- Customizable animation parameters

### State Management
- Tracks menu open/closed state
- Handles orientation changes
- Manages view controller lifecycle

## Best Practices

### Memory Management

```swift
class ViewController: UIViewController {
    private var containerController: SideMenuContainerViewController?
    
    func setupMenu() {
        let container = SideMenuContainerViewController(
            items: menuItems,
            configuration: config,
            homeViewController: HomeViewController()
        )
        
        // Store strong reference
        containerController = container
        
        // Add as child view controller
        addChild(container)
        view.addSubview(container.view)
        container.didMove(toParent: self)
    }
}
```

### View Controller Lifecycle

```swift
class ViewController: UIViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Update menu layout for new size
        containerController?.viewWillTransition(to: size, with: coordinator)
    }
}
```

### Navigation Integration

```swift
class ViewController: UIViewController {
    func setupNavigation() {
        // Add menu button to navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .plain,
            target: containerController,
            action: #selector(SideMenuContainerViewController.toggleMenu)
        )
    }
}
```

## Topics

### Essentials
- ``init(items:configuration:cellType:homeViewController:)``
- ``toggleMenu()``
- ``resetHome()``

### View Controller Management
- ``changeView(to:)``
- ``addChild(_:)``
- ``removeFromParent()``

### State Management
- ``isMenuOpen``
- ``viewWillTransition(to:with:)``
- ``viewDidLayoutSubviews()``

### Customization
- ``configuration``
- ``animator``
- ``blurEffectView``

## See Also

- ``SideMenuViewController``
- ``SideMenuConfiguration``
- ``SideMenuAnimator`` 