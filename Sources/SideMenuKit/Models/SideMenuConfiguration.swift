import UIKit

/// Configuration options for the side menu appearance and behavior.
///
/// Use this structure to customize various aspects of the side menu, including:
/// - Menu dimensions and positioning
/// - Animation parameters
/// - Visual appearance
/// - Cell configuration
///
/// Example usage:
/// ```swift
/// let config = SideMenuConfiguration(
///     menuWidth: 300,
///     menuYOffset: 100,
///     menuScaleFactor: 0.8,
///     backgroundColor: .systemBackground,
///     blurStyle: .regular
/// )
/// ```
public struct SideMenuConfiguration {

        // MARK: - Default Values
    /// Default menu width (40% of screen width)
    private static let defaultMenuWidth: CGFloat = UIScreen.main.bounds.width * 0.4
    /// Default menu Y offset (15% of screen height)
    private static let defaultMenuYOffset: CGFloat = UIScreen.main.bounds.height * 0.15
    /// Default scale factor for the main view when menu is open
    private static let defaultMenuScaleFactor: CGFloat = 0.85
    /// Default duration for open/close animations
    private static let defaultAnimationDuration: TimeInterval = 0.4
    /// Default spring damping for animations
    private static let defaultSpringDamping: CGFloat = 0.8
    /// Default initial spring velocity for animations
    private static let defaultInitialSpringVelocity: CGFloat = 0
    /// Default corner radius for the menu when open
    private static let defaultCornerRadius: CGFloat = 40

        // MARK: - Public Properties
    /// The width of the side menu.
    /// This determines how much of the screen the menu will occupy when fully open.
    public let menuWidth: CGFloat
    /// The vertical offset of the main view when the menu is open.
    /// This creates a parallax effect as the main view slides to reveal the menu.
    public let menuYOffset: CGFloat
    /// The scale factor applied to the main view when the menu is open.
    /// Values less than 1.0 will cause the main view to shrink when the menu opens.
    public let menuScaleFactor: CGFloat
    /// The duration of the open/close animation in seconds.
    public let animationDuration: TimeInterval
    /// The damping ratio for the spring animation.
    /// Values closer to 1.0 will create more dampened animations.
    public let springDamping: CGFloat
    /// The initial velocity for the spring animation.
    /// Higher values create more energetic initial animation.
    public let initialSpringVelocity: CGFloat
    /// The background color of the menu.
    /// If nil, the menu will be transparent.
    public let backgroundColor: UIColor?
    /// The blur effect style to apply to the menu background.
    /// If nil, no blur effect will be applied.
    public let blurStyle: UIBlurEffect.Style?
    /// The corner radius applied to the main view when the menu is open.
    public let cornerRadius: CGFloat
    /// The configuration for the menu cells.
    public let cellConfiguration: CellConfiguration

    /// Creates a new menu configuration with customizable parameters.
    /// - Parameters:
    ///   - menuWidth: Width of the menu. Defaults to 40% of screen width.
    ///   - menuYOffset: Vertical offset when menu is open. Defaults to 15% of screen height.
    ///   - menuScaleFactor: Scale factor for main view when menu is open. Defaults to 0.85.
    ///   - animationDuration: Duration of open/close animation. Defaults to 0.4 seconds.
    ///   - springDamping: Spring animation damping. Defaults to 0.8.
    ///   - initialSpringVelocity: Initial spring velocity. Defaults to 0.
    ///   - backgroundColor: Background color of the menu. Defaults to nil.
    ///   - blurStyle: Blur effect style. Defaults to .regular.
    ///   - cornerRadius: Corner radius when menu is open. Defaults to 40.
    ///   - cellType: Type of cell to use for menu items. Defaults to DefaultSideMenuCell.
    public init(
        menuWidth: CGFloat? = nil,
        menuYOffset: CGFloat? = nil,
        menuScaleFactor: CGFloat? = nil,
        animationDuration: TimeInterval? = nil,
        springDamping: CGFloat? = nil,
        initialSpringVelocity: CGFloat? = nil,
        backgroundColor: UIColor? = nil,
        blurStyle: UIBlurEffect.Style? = .regular,
        cornerRadius: CGFloat? = nil,
        cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self
    ) {
        self.menuWidth = menuWidth ?? Self.defaultMenuWidth
        self.menuYOffset = menuYOffset ?? Self.defaultMenuYOffset
        self.menuScaleFactor = menuScaleFactor ?? Self.defaultMenuScaleFactor
        self.animationDuration = animationDuration ?? Self.defaultAnimationDuration
        self.springDamping = springDamping ?? Self.defaultSpringDamping
        self.initialSpringVelocity = initialSpringVelocity ?? Self.defaultInitialSpringVelocity
        self.backgroundColor = backgroundColor
        self.blurStyle = blurStyle
        self.cornerRadius = cornerRadius ?? Self.defaultCornerRadius
        self.cellConfiguration = CellConfiguration(cellType)
    }
}

/// Configuration for the menu cells.
///
/// This structure holds the cell class type and reuse identifier for the menu cells.
/// It's used internally by the menu to register and dequeue cells.
///
/// Example usage:
/// ```swift
/// let cellConfig = CellConfiguration(CustomMenuCell.self)
/// ```
public struct CellConfiguration {
    /// The cell class type that conforms to SideMenuCellProtocol
    let cellClass: SideMenuCellProtocol.Type
    
    /// The reuse identifier for the cell
    let reuseIdentifier: String

    /// Creates a new cell configuration.
    /// - Parameter cellType: The type of cell to use for menu items.
    public init<T: SideMenuCellProtocol>(_ cellType: T.Type) {
        self.cellClass = cellType
        self.reuseIdentifier = cellType.reuseIdentifier
    }
}
