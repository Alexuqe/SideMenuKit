# ``SideMenuKit``

A lightweight and highly customizable side menu implementation for iOS applications.

## Overview

SideMenuKit is a modern Swift library that provides an elegant and customizable side menu solution for iOS applications. Built with iOS 15+ in mind, it offers a rich set of features and customization options while maintaining excellent performance and ease of use.

![SideMenu Example](sidemenu_example.png)

## Key Features

### Smooth Animations
The library uses spring-based animations to provide natural, fluid transitions when opening and closing the menu. All animation parameters are customizable, allowing you to fine-tune the feel of your menu.

### Rich Customization
Every aspect of the menu can be customized:
- Menu dimensions and positioning
- Animation timing and dynamics
- Visual appearance (colors, blur effects, corner radius)
- Menu item appearance and behavior
- Custom cell implementations

### Modern Architecture
Built using modern Swift features and following iOS best practices:
- Protocol-oriented design
- Type-safe APIs
- Proper memory management
- Safe area awareness
- Support for dark mode

### Easy Integration
Integrate the menu into your app with just a few lines of code:

```swift
// Create menu items
let menuItems = [
    MenuItem(title: "Home", icon: UIImage(systemName: "house")),
    MenuItem(title: "Profile", icon: UIImage(systemName: "person"))
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

## Topics

### Essentials
- <doc:GettingStarted>
- ``SideMenuContainerViewController``
- ``SideMenuViewController``

### Configuration
- ``SideMenuConfiguration``
- ``CellConfiguration``

### Protocols
- ``SideMenuItemProtocol``
- ``SideMenuCellProtocol``
- ``SideMenuDelegate``
- ``SideMenuAnimatorProtocol``

### Default Implementations
- ``DefaultSideMenuCell``
- ``SideMenuAnimator``

## Installation

### Swift Package Manager

Add SideMenuKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SideMenuKit.git", from: "1.0.0")
]
```

### Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## Best Practices

### Memory Management
- Use weak references for delegates
- Clean up observers and timers
- Handle view controller lifecycle properly

### Performance
- Avoid heavy computations during animations
- Use appropriate image sizes
- Cache frequently used resources

### Accessibility
- Provide meaningful accessibility labels
- Support Dynamic Type
- Ensure proper contrast ratios

### State Management
- Handle orientation changes
- Manage menu state properly
- Support app lifecycle events

## See Also

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) 