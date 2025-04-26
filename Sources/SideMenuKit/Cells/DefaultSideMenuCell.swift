import UIKit

/// The default implementation of a menu cell.
///
/// This class provides a standard layout for menu items with an icon and title.
/// It supports all customization options defined in `SideMenuItemProtocol`
/// and provides smooth selection animations.
///
/// The cell layout consists of:
/// - A container view with customizable background and corner radius
/// - An icon image view that supports custom tint colors and sizes
/// - A title label with support for custom fonts and attributed text
///
/// Example usage:
/// ```swift
/// let sideMenuController = SideMenuContainerViewController(
///     items: menuItems,
///     configuration: config,
///     cellType: DefaultSideMenuCell.self,
///     homeViewController: HomeViewController()
/// )
/// ```
open class DefaultSideMenuCell: UITableViewCell, SideMenuCellProtocol {
    // MARK: - UI Components
    
    /// The image view that displays the menu item's icon.
    /// Configured with aspect fit content mode for proper icon display.
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// The label that displays the menu item's title.
    /// Supports both plain text and attributed strings.
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    /// Creates a new instance of the default menu cell.
    /// - Parameters:
    ///   - style: The cell style (unused in this implementation)
    ///   - reuseIdentifier: The reuse identifier for the cell
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /// Sets up the cell's layout using Auto Layout constraints.
    /// This method is called during initialization to establish the visual hierarchy
    /// and constraints for the cell's subviews.
    private func setupLayout() {
        clipsToBounds = true

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title constraints
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with a menu item.
    ///
    /// This method applies all the customization options from the menu item to the cell:
    /// - Sets the icon image and tint color
    /// - Configures the title text and font
    /// - Applies background colors and corner radius
    /// - Sets up the selection state appearance
    ///
    /// - Parameter item: The menu item to configure the cell with
    open func configure(with item: SideMenuItemProtocol) {
        backgroundColor = item.backgroundColor ?? .clear

        // Configure selection background
        let backgroundView = UIView()
        backgroundView.backgroundColor = item.selectedBackGroundColor?
            .withAlphaComponent(0.4) ?? .white.withAlphaComponent(0.4)
        selectedBackgroundView = backgroundView

        // Apply corner radius
        layer.cornerRadius = item.cellCornerRadius ?? 20

        // Configure content
        var content = defaultContentConfiguration()
        content.imageProperties.preferredSymbolConfiguration = .init(pointSize: item.iconSize ?? 20)
        content.imageProperties.tintColor = item.iconColor ?? .white
        content.image = item.icon

        // Configure title
        content.attributedText = NSAttributedString(
            string: item.title,
            attributes: item.attributedTitle ??
            [.font: UIFont.systemFont(ofSize: 20, weight: .regular),
             .foregroundColor: UIColor.white
            ]
        )

        contentConfiguration = content
    }
}
