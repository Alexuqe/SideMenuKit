# ``SideMenuViewController``

A view controller that manages the side menu's content and interaction.

## Overview

`SideMenuViewController` is responsible for displaying the menu items and handling user interactions with the menu. It manages a table view that displays the menu items and coordinates with its delegate to handle item selection.

## Topics

### Creating a Menu Controller

```swift
public init(
    items: [SideMenuItemProtocol],
    configuration: SideMenuConfiguration,
    cellType: SideMenuCellProtocol.Type
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
let config = SideMenuConfiguration()

// Initialize menu controller
let menuController = SideMenuViewController(
    items: menuItems,
    configuration: config,
    cellType: DefaultSideMenuCell.self
)

// Set delegate
menuController.delegate = self
```

## Features

### Menu Item Management
- Displays menu items in a table view
- Supports custom cell types
- Handles item selection
- Manages item appearance

### Layout Management
- Handles safe area insets
- Supports dynamic type
- Manages table view constraints
- Handles orientation changes

### Customization
- Supports custom cell types
- Configurable appearance
- Flexible layout options
- Dynamic content updates

### Delegate Pattern
- Reports item selection
- Coordinates with container
- Handles navigation

## Implementation Details

### Table View Setup

```swift
private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    // Register cell type
    let cellConfig = configuration.cellConfiguration
    tableView.register(
        cellConfig.cellClass,
        forCellReuseIdentifier: cellConfig.reuseIdentifier
    )
    
    // Configure layout
    NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
}
```

### Delegate Implementation

```swift
extension MyViewController: SideMenuDelegate {
    func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol) {
        // Handle item selection
        if let viewController = item.viewController {
            // Present the associated view controller
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        // Close the menu
        containerController?.toggleMenu()
    }
}
```

### Custom Cell Registration

```swift
class CustomMenuViewController: SideMenuViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom cell type
        tableView.register(
            CustomMenuCell.self,
            forCellReuseIdentifier: CustomMenuCell.reuseIdentifier
        )
    }
}
```

## Best Practices

### Memory Management
- Use weak delegate references
- Clean up any observers
- Handle view lifecycle properly

### Performance
- Reuse cells efficiently
- Cache expensive computations
- Optimize image loading

### Accessibility
- Provide clear labels
- Support VoiceOver
- Handle dynamic type

## Topics

### Essentials
- ``init(items:configuration:cellType:)``
- ``delegate``
- ``items``

### Table View Management
- ``tableView``
- ``setupTableView()``
- ``registerCells()``

### Delegate Methods
- ``SideMenuDelegate``
- ``didSelectItem(_:)``

### Customization
- ``configuration``
- ``updateAppearance()``

## See Also

- ``SideMenuContainerViewController``
- ``SideMenuItemProtocol``
- ``SideMenuCellProtocol`` 