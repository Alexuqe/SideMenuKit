import UIKit

open class SideMenuContainerViewController: UIViewController {
    // MARK: - Properties
    private weak var navigationVC: UINavigationController?
    private var mainViewController: UIViewController
    private let homeViewController: UIViewController
    private let sideMenuViewController: SideMenuViewController
    private let animator: SideMenuAnimatorProtocol
    private var viewTitle: SideMenuItemProtocol?
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

    private var mainView: UIView {
        return navigationVC?.view ?? view
    }

    // MARK: - Initialization
    public init(
        items: [SideMenuItemProtocol],
        configuration: SideMenuConfiguration = SideMenuConfiguration(),
        cellType: SideMenuCellProtocol.Type = DefaultSideMenuCell.self,
        homeViewController: UIViewController
    ) {
        self.configuration = configuration
        self.sideMenuViewController = SideMenuViewController(
            items: items,
            configuration: configuration,
            cellType: cellType
        )

        self.homeViewController = homeViewController
        self.mainViewController = homeViewController
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

        let navigationController = UINavigationController(rootViewController: mainViewController)
        addChild(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        self.navigationVC = navigationController

        if let blurEffectView = blurEffectView {
            navigationVC?.view.addSubview(blurEffectView)
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
        view.addGestureRecognizer(tapGesture)
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

    // MARK: - Navigation
    public func resetHome() {
        guard let mainVC = navigationVC?.viewControllers.first else { return }

        mainVC.children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        mainVC.addChild(homeViewController)
        mainVC.view.addSubview(homeViewController.view)
        homeViewController.view.frame = mainVC.view.bounds
        homeViewController.didMove(toParent: mainVC)

        let title = viewTitle?.title
        mainVC.title = homeViewController.title ?? title
    }

    private func changeView(to newController: UIViewController) {
        guard let mainVC = navigationVC?.viewControllers.first else { return }

        mainVC.children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        mainVC.addChild(newController)
        mainVC.view.addSubview(newController.view)
        newController.view.frame = mainVC.view.bounds
        newController.didMove(toParent: mainVC)

        let title = viewTitle?.title
        mainVC.title = newController.title ?? title
    }
}

// MARK: - SideMenuDelegate
extension SideMenuContainerViewController: SideMenuDelegate {
    public func sideMenu(_ sideMenu: SideMenuViewController, didSelectItem item: SideMenuItemProtocol) {
        if let viewController = item.viewController {
            viewController.title = item.title
            changeView(to: viewController)
        } else {
            resetHome()
        }
        toggleMenu()
    }
}
