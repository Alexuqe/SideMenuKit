import UIKit

public struct SideMenuConfiguration {
    public struct Animation {
        public let duration: TimeInterval
        public let dampingRatio: CGFloat
        public let contentScaleFactor: CGFloat
        public let springVelocity: CGFloat

        public init(
            duration: TimeInterval = 0.4,
            dampingRatio: CGFloat = 0.8,
            contentScaleFactor: CGFloat = 0.9,
            springVelocity: CGFloat = 0.0
        ) {
            self.duration = duration
            self.dampingRatio = dampingRatio
            self.contentScaleFactor = contentScaleFactor
            self.springVelocity = springVelocity
        }
    }

    public struct Appearance {
        public let menuWidth: CGFloat
        public let menuBackgroundColor: UIColor
        public let blurEffect: UIBlurEffect?
        public let cornerRadius: CGFloat

        public init(
            menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4,
            menuBackgroundColor: UIColor = .systemBackground,
            blurEffect: UIBlurEffect? = UIBlurEffect(style: .systemMaterial),
            cornerRadius: CGFloat = 12.0
        ) {
            self.menuWidth = menuWidth
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
