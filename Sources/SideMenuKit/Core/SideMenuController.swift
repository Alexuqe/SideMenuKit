import UIKit

@MainActor
public final class SideMenuController: NSObject {
    // MARK: - Public Properties
    public weak var delegate: (any SideMenuDelegate)?
    public var navigator: (any SideMenuNavigator)?

    // MARK: - Private Properties
    private let configuration: SideMenuConfiguration
    private let menuViewController: SideMenuViewController
    private let containerView: UIView
    private let contentViewController: UIViewController
    private var blurView: UIVisualEffectView?
    private var isMenuOpen = false
    private var panGestureRecognizer: UIPanGestureRecognizer?

    // MARK: - Initialization
    public init(
        configuration: SideMenuConfiguration,
        contentViewController: UIViewController,
        containerView: UIView
    ) {
        self.configuration = configuration
        self.contentViewController = contentViewController
        self.containerView = containerView
        self.menuViewController = SideMenuViewController(configuration: configuration)

        super.init()
        setupHierarchy()
        setupGestures()
    }

    // MARK: - Public Methods
    public func toggleMenu() {
        isMenuOpen ? hideMenu() : showMenu()
    }

    public func updateLayout() {
        menuViewController.view.frame = CGRect(
            x: isMenuOpen ? 0 : -configuration.appearance.menuWidth,
            y: 0,
            width: configuration.appearance.menuWidth,
            height: containerView.bounds.height
        )
    }

    // Добавленный метод
    public func setDefaultNavigation(viewControllers: [UIViewController]) {
        navigator = DefaultReplacementNavigator(
            container: contentViewController,
            viewControllers: viewControllers
        )
    }
}

// MARK: - Setup & Animation
extension SideMenuController {
    func setupHierarchy() {
        menuViewController.view.frame = CGRect(
            x: -configuration.appearance.menuWidth,
            y: 0,
            width: configuration.appearance.menuWidth,
            height: containerView.bounds.height
        )

        containerView.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: contentViewController)

        if let blurEffect = configuration.appearance.blurEffect {
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView?.frame = containerView.bounds
            blurView?.alpha = 0
            containerView.insertSubview(blurView!, belowSubview: menuViewController.view)
        }
    }

    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.delegate = self
        blurView?.addGestureRecognizer(tapGesture)

        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        containerView.addGestureRecognizer(panGestureRecognizer!)
    }

    func showMenu() {
        guard !isMenuOpen else { return }

        UIView.animate(
            withDuration: configuration.animation.duration,
            delay: 0,
            usingSpringWithDamping: configuration.animation.dampingRatio,
            initialSpringVelocity: 0
        ) { [weak self] in
            guard let self = self else { return }
            self.menuViewController.view.frame.origin.x = 0
            self.contentViewController.view.transform = CGAffineTransform(
                scaleX: self.configuration.animation.contentScaleFactor,
                y: self.configuration.animation.contentScaleFactor
            )
            self.blurView?.alpha = 1.0
            self.contentViewController.view.layer.cornerRadius = self.configuration.appearance.cornerRadius
        }
        isMenuOpen = true
        delegate?.menuStateChanged(isOpen: true)
    }

    func hideMenu() {
        guard isMenuOpen else { return }

        UIView.animate(
            withDuration: configuration.animation.duration,
            delay: 0,
            usingSpringWithDamping: configuration.animation.dampingRatio,
            initialSpringVelocity: 0
        ) { [weak self] in
            guard let self = self else { return }
            self.menuViewController.view.frame.origin.x = -self.configuration.appearance.menuWidth
            self.contentViewController.view.transform = .identity
            self.blurView?.alpha = 0
            self.contentViewController.view.layer.cornerRadius = 0
        }
        isMenuOpen = false
        delegate?.menuStateChanged(isOpen: false)
    }
}

// MARK: - Gesture Handling
extension SideMenuController: UIGestureRecognizerDelegate {
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        hideMenu()
    }

    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: containerView)
        let velocity = recognizer.velocity(in: containerView)

        switch recognizer.state {
        case .changed:
            let progress = translation.x / configuration.appearance.menuWidth
            let constrainedProgress = min(max(progress, 0), 1)

            menuViewController.view.frame.origin.x = -configuration.appearance.menuWidth +
                constrainedProgress * configuration.appearance.menuWidth

            let scale = 1 - (1 - configuration.animation.contentScaleFactor) * constrainedProgress
            contentViewController.view.transform = CGAffineTransform(scaleX: scale, y: scale)
            blurView?.alpha = constrainedProgress

        case .ended:
            let shouldOpen = velocity.x > 500 || translation.x > configuration.appearance.menuWidth/2
            shouldOpen ? showMenu() : hideMenu()

        default: break
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isMenuOpen || gestureRecognizer == panGestureRecognizer
    }
}
