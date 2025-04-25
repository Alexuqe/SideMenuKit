import UIKit

public struct SideMenuConfiguration {
    // MARK: - Appearance
    public struct Appearance {
        public let menuWidth: CGFloat
        public let menuBackgroundColor: UIColor
        public let blurEffect: UIBlurEffect?
        public let cornerRadius: CGFloat

        public init(
            menuWidth: CGFloat,
            menuBackgroundColor: UIColor,
            blurEffect: UIBlurEffect?,
            cornerRadius: CGFloat
        ) {
            self.menuWidth = menuWidth
            self.menuBackgroundColor = menuBackgroundColor
            self.blurEffect = blurEffect
            self.cornerRadius = cornerRadius
        }
    }

    // MARK: - Animation
    public struct Animation {
        public let duration: TimeInterval
        public let dampingRatio: CGFloat
        public let contentScaleFactor: CGFloat

        public init(
            duration: TimeInterval = 0.4,
            dampingRatio: CGFloat = 0.8,
            contentScaleFactor: CGFloat = 0.9
        ) {
            self.duration = duration
            self.dampingRatio = dampingRatio
            self.contentScaleFactor = contentScaleFactor
        }
    }

    // MARK: - Properties
    public let items: [any SideMenuItem]
    public let appearance: Appearance
    public let animation: Animation
    public let cellType: SideMenuCellProtocol.Type?

    public init(
        items: [any SideMenuItem],
        appearance: Appearance,
        animation: Animation = Animation(),
        cellType: SideMenuCellProtocol.Type? = nil
    ) {
        self.items = items
        self.appearance = appearance
        self.animation = animation
        self.cellType = cellType
    }
}

public extension SideMenuConfiguration.Appearance {
    static func `default`(menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4) -> Self {
        .init(
            menuWidth: menuWidth,
            menuBackgroundColor: .systemBackground,
            blurEffect: UIBlurEffect(style: .systemMaterial),
            cornerRadius: 12.0
        )
    }
}
