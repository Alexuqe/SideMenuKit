import UIKit

open class SideMenuContainerViewController: UIViewController {
        // MARK: - Properties
    private let sideMenuViewController: SideMenuViewController
    private let animator: SideMenuAnimatorProtocol
    private var mainViewController: UIViewController
    private var customNavigationController: UINavigationController?
    private let configuration: SideMenuConfiguration

    private var isMenuOpen = false
    private var useNavigationController: Bool

    private lazy var blurEffectView: UIVisualEffectView? = {
        guard let blurStyle = configuration.blurStyle else { return nil }
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.0
        return blurView
    }()

    private var mainView: UIView {
        return customNavigationController?.view ?? mainViewController.view
    }

        // MARK: - Initialization
    public init(
        items: [SideMenuItemProtocol],
        configuration: SideMenuConfiguration = SideMenuConfiguration(),
        cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self,
        navigationController: UINavigationController? = nil
    ) {
        self.configuration = configuration
        self.sideMenuViewController = SideMenuViewController(
            items: items,
            configuration: configuration,
            cellType: cellType
        )
        self.mainViewController = items.first?.viewController ?? UIViewController()

        if let existingNavController = navigationController {
            self.customNavigationController = existingNavController
            self.useNavigationController = true
        } else {
            self.customNavigationController = UINavigationController(rootViewController: self.mainViewController)
            self.useNavigationController = true
        }

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
    }

        // MARK: - Setup
    private func setupLayout() {
            // Setup side menu
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)

        if let navController = customNavigationController {
            if navController.viewControllers.isEmpty {
                navController.setViewControllers([mainViewController], animated: false)
            }

            addChild(navController)
            view.addSubview(navController.view)
            navController.didMove(toParent: self)

            if let blurEffectView = blurEffectView {
                navController.view.addSubview(blurEffectView)
            }
        }

        setupConstraints()
    }

    private func setupConstraints() {
        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        mainView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sideMenuViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: configuration.menuWidth)
        ])

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if let blurView = blurEffectView {
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: mainView.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
                blurView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
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
            view: mainView,
            isOpen: isMenuOpen,
            configuration: configuration,
            blurView: blurEffectView,
            completion: nil
        )
    }

    public func getNavigationController() -> UINavigationController {
        return customNavigationController ?? UINavigationController()
    }
}

    // MARK: - SideMenuDelegate
extension SideMenuContainerViewController: SideMenuDelegate {
    public func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol) {
        if let navController = customNavigationController {
            navController.setViewControllers([item.viewController], animated: false)
        }
        
        toggleMenu()
    }
}
