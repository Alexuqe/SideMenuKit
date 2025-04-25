import UIKit

public struct SideMenuConfiguration {

        // MARK: - Default Values
    private static let defaultMenuWidth: CGFloat = UIScreen.main.bounds.width * 0.4
    private static let defaultMenuYOffset: CGFloat = UIScreen.main.bounds.height * 0.15
    private static let defaultMenuScaleFactor: CGFloat = 0.85
    private static let defaultAnimationDuration: TimeInterval = 0.4
    private static let defaultSpringDamping: CGFloat = 0.8
    private static let defaultInitialSpringVelocity: CGFloat = 0
    private static let defaultCornerRadius: CGFloat = 40

        // MARK: - Public Properties
    public let menuWidth: CGFloat
    public let menuYOffset: CGFloat
    public let menuScaleFactor: CGFloat
    public let animationDuration: TimeInterval
    public let springDamping: CGFloat
    public let initialSpringVelocity: CGFloat
    public let backgroundColor: UIColor?
    public let blurStyle: UIBlurEffect.Style?
    public let cornerRadius: CGFloat
    public let cellConfiguration: CellConfiguration

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

public struct CellConfiguration {
    let cellClass: SideMenuCellProtocol.Type
    let reuseIdentifier: String

    public init<T: SideMenuCellProtocol>(_ cellType: T.Type) {
        self.cellClass = cellType
        self.reuseIdentifier = cellType.reuseIdentifier
    }
}
