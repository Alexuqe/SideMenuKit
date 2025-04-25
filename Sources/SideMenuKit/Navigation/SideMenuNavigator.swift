import UIKit

public protocol SideMenuNavigator: AnyObject {
    var viewControllers: [UIViewController] { get }
    func navigateTo(index: Int)
}
