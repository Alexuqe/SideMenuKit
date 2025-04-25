import UIKit

public protocol SideMenuCellProtocol: UITableViewCell {
    static var reuseIdentifier: String { get }
    func configure(with item: any SideMenuItem)
}
