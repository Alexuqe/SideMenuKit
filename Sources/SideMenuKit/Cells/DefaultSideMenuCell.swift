import UIKit

public final class DefaultSideMenuCell: UITableViewCell, SideMenuCellProtocol {
    public static var reuseIdentifier: String { "DefaultSideMenuCell" }

    public func configure(with item: any SideMenuItem) {
        var config = defaultContentConfiguration()
        config.text = item.title
        config.image = item.icon?.withTintColor(.label, renderingMode: .alwaysOriginal)
        config.textProperties.color = .label
        config.textProperties.font = .preferredFont(forTextStyle: .body)
        contentConfiguration = config

        backgroundColor = .clear
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .systemFill
    }
}
