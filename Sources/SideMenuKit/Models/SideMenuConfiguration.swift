import UIKit

public struct SideMenuConfiguration {
    public struct Appearance {
        public let menuWidth: CGFloat
        public let menuBackgroundColor: UIColor
        public let blurEffect: UIBlurEffect?
        public let cornerRadius: CGFloat

        @MainActor
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

    public let items: [any SideMenuItem]
    public let appearance: Appearance
    public let animation: Animation
    public let cellType: SideMenuCellProtocol.Type?

    @MainActor
    public init(
        items: [any SideMenuItem],
        appearance: Appearance = Appearance(),
        animation: Animation = Animation(),
        cellType: SideMenuCellProtocol.Type? = nil
    ) {
        self.items = items
        self.appearance = appearance
        self.animation = animation
        self.cellType = cellType
    }
}
