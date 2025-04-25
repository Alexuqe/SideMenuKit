import UIKit

final class DefaultSideMenuCell: UITableViewCell, SideMenuCellProtocol {
    static var reuseIdentifier: String { "DefaultSideMenuCell" }

    func configure(with item: any SideMenuItem) {
        var config = defaultContentConfiguration()
        config.text = item.title
        config.image = item.icon?.withRenderingMode(.alwaysTemplate)
        config.imageProperties.tintColor = .label
        config.textProperties.color = .label
        config.textProperties.font = .preferredFont(forTextStyle: .body)
        contentConfiguration = config

        backgroundColor = .clear
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .systemFill
    }
}
