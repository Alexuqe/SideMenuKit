import UIKit

open class SideMenuContainerViewController: UIViewController {
    // MARK: - Properties
    private let sideMenuViewController: SideMenuViewController
    private let animator: SideMenuAnimatorProtocol
    private var mainViewController: UIViewController
    private let configuration: SideMenuConfiguration
    private var isMenuOpen = false

    private lazy var blurEffectView: UIVisualEffectView? = {
        guard let blurStyle = configuration.blurStyle else { return nil }
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.0
        return blurView
    }()

    // MARK: - Initialization
    public init(
        items: [SideMenuItemProtocol],
        configuration: SideMenuConfiguration = SideMenuConfiguration(),
        cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self
    ) {
        self.configuration = configuration
        self.sideMenuViewController = SideMenuViewController(
            items: items,
            configuration: configuration,
            cellType: cellType
        )
        self.mainViewController = items.first?.viewController ?? UIViewController()
        self.animator = SideMenuAnimator()

        super.init(nibName: nil, bundle: nil)
        sideMenuViewController.delegate = self
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupGestures()
        
        // Set initial view controller if needed
        if navigationController?.viewControllers.count == 1 {
            navigationController?.setViewControllers([mainViewController], animated: false)
        }
    }

    // MARK: - Setup
    private func setupLayout() {
        // Setup side menu
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)

        if let blurEffectView = blurEffectView {
            view.addSubview(blurEffectView)
            view.bringSubviewToFront(blurEffectView)
        }

        setupConstraints()
    }

    private func setupConstraints() {
        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: configuration.menuWidth)
        ])

        if let blurView = blurEffectView {
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: view.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        blurEffectView?.addGestureRecognizer(tapGesture)
    }

    // MARK: - Actions
    @objc private func handleTapGesture() {
        toggleMenu()
    }

    public func toggleMenu() {
        isMenuOpen.toggle()
        animator.animate(
            view: navigationController?.view ?? view,
            isOpen: isMenuOpen,
            configuration: configuration,
            blurView: blurEffectView,
            completion: nil
        )
    }
}

// MARK: - SideMenuDelegate
extension SideMenuContainerViewController: SideMenuDelegate {
    public func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol) {
        navigationController?.setViewControllers([item.viewController], animated: false)
        toggleMenu()
    }
}
