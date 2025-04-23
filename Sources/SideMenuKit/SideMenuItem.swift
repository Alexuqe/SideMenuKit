import UIKit

public struct SideMenuItem {
    public let title: String
    public let image: UIImage?

    public init(title: String, image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
