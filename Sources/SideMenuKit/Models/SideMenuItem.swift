import UIKit

public protocol SideMenuItem: Hashable {
    var title: String { get }
    var icon: UIImage? { get }
}
