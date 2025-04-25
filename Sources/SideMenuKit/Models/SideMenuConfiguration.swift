import UIKit

public struct SideMenuConfiguration {
    public struct Animation {
        public let duration: TimeInterval
        public let dampingRatio: CGFloat
        public let contentScaleFactor: CGFloat
        public let menuOffsetX: CGFloat
        public let menuOffsetY: CGFloat
        public let cornerRadius: CGFloat
        public let blurAlpha: CGFloat

        public init(
            duration: TimeInterval = 0.4,
            dampingRatio: CGFloat = 0.8,
            contentScaleFactor: CGFloat = 0.8,
            menuOffsetX: CGFloat = 30,
            menuOffsetY: CGFloat = 30,
            cornerRadius: CGFloat = 40,
            blurAlpha: CGFloat = 0.9
        ) {
            self.duration = duration
            self.dampingRatio = dampingRatio
            self.contentScaleFactor = contentScaleFactor
            self.menuOffsetX = menuOffsetX
            self.menuOffsetY = menuOffsetY
            self.cornerRadius = cornerRadius
            self.blurAlpha = blurAlpha
        }
    }

    public struct Appearance {
        public let menuWidth: CGFloat
        public let menuBackgroundColor: UIColor
        public let blurEffect: UIBlurEffect?
        public let cornerRadius: CGFloat

        public init(
            menuWidth: CGFloat? = nil,
            menuBackgroundColor: UIColor = .systemBackground,
            blurEffect: UIBlurEffect? = UIBlurEffect(style: .systemMaterial),
            cornerRadius: CGFloat = 12.0
        ) {
            self.menuWidth = menuWidth ?? (UIScreen.main.bounds.width * 0.4)
            self.menuBackgroundColor = menuBackgroundColor
            self.blurEffect = blurEffect
            self.cornerRadius = cornerRadius
        }
    }

    public let items: [any SideMenuItem]
    public let animation: Animation
    public let appearance: Appearance
    public let cellType: SideMenuCellProtocol.Type?

    public init(
        items: [any SideMenuItem],
        animation: Animation = Animation(),
        appearance: Appearance = Appearance(),
        cellType: SideMenuCellProtocol.Type? = nil
    ) {
        self.items = items
        self.animation = animation
        self.appearance = appearance
        self.cellType = cellType
    }
}
