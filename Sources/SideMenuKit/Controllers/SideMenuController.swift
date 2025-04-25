import UIKit

@MainActor
public final class SideMenuController: NSObject {
    public weak var delegate: SideMenuDelegate?

    private let configuration: SideMenuConfiguration
    private let menuViewController: SideMenuViewController
    private let containerView: UIView
    private let contentViewController: UIViewController

    private var blurView: UIVisualEffectView?
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?

    private var isMenuOpen = false
    private var contentViewOriginalTransform = CGAffineTransform.identity

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

    public func toggleMenu() {
        isMenuOpen ? hideMenu() : showMenu()
    }

    public func updateConfiguration(_ newConfig: SideMenuConfiguration) {
        menuViewController.updateConfiguration(newConfig)
        adjustLayoutForCurrentOrientation()
    }
}

// MARK: - Setup
private extension SideMenuController {
    func setupHierarchy() {
        menuViewController.view.frame = CGRect(
            x: -configuration.appearance.menuWidth,
            y: 0,
            width: configuration.appearance.menuWidth,
            height: containerView.bounds.height
        )

        containerView.addSubview(menuViewController.view)
        menuViewController.didMove(toParent: contentViewController)

        setupBlurEffect()
    }

    func setupBlurEffect() {
        guard let blurEffect = configuration.appearance.blurEffect else { return }

        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.frame = containerView.bounds
        blurView?.alpha = 0
        containerView.insertSubview(blurView!, belowSubview: menuViewController.view)
    }

    func setupGestures() {
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        )
        
        tapGestureRecognizer?.delegate = self
        blurView?.addGestureRecognizer(tapGestureRecognizer!)

        panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan))
        panGestureRecognizer?.delegate = self
        containerView.addGestureRecognizer(panGestureRecognizer!)
    }
}

// MARK: - Animation Handling
private extension SideMenuController {
    func showMenu() {
        guard !isMenuOpen else { return }

        animateMenu(show: true) { [weak self] in
            self?.isMenuOpen = true
            self?.delegate?.menuStateChanged(isOpen: true)
        }
    }

    func hideMenu() {
        guard isMenuOpen else { return }

        animateMenu(show: false) { [weak self] in
            self?.isMenuOpen = false
            self?.delegate?.menuStateChanged(isOpen: false)
        }
    }

    func animateMenu(show: Bool, completion: (() -> Void)? = nil) {
        let targetX = show ? 0 : -configuration.appearance.menuWidth
        let contentScale = show ? configuration.animation.contentScaleFactor : 1.0

        UIView.animate(
            withDuration: configuration.animation.duration,
            delay: 0,
            usingSpringWithDamping: configuration.animation.dampingRatio,
            initialSpringVelocity: configuration.animation.springVelocity,
            options: [.curveEaseInOut, .allowUserInteraction]
        ) { [weak self] in
            guard let self = self else { return }

            self.menuViewController.view.frame.origin.x = targetX
            self.contentViewController.view.transform = CGAffineTransform(
                scaleX: contentScale,
                y: contentScale
            )
            self.blurView?.alpha = show ? 1.0 : 0.0
            self.contentViewController.view.layer.cornerRadius = show ?
                self.configuration.appearance.cornerRadius : 0
        } completion: { _ in
            completion?()
        }
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
        case .began:
            contentViewOriginalTransform = contentViewController.view.transform

        case .changed:
            let progress = translation.x / configuration.appearance.menuWidth
            let constrainedProgress = min(max(progress, 0), 1)

            let menuTransform = CGAffineTransform(
                translationX: constrainedProgress * configuration.appearance.menuWidth,
                y: 0
            )

            let contentScale = 1 - (1 - configuration.animation.contentScaleFactor) * constrainedProgress
            contentViewController.view.transform = contentViewOriginalTransform
                .scaledBy(x: contentScale, y: contentScale)

            menuViewController.view.transform = menuTransform

        case .ended:
            let shouldOpen = velocity.x > 500 || abs(translation.x) > configuration.appearance.menuWidth / 2
            shouldOpen ? showMenu() : hideMenu()

        default:
            break
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return isMenuOpen || gestureRecognizer == panGestureRecognizer
    }
}

// MARK: - Rotation Handling
extension SideMenuController {
    private func adjustLayoutForCurrentOrientation() {
        let menuWidth = configuration.appearance.menuWidth
        menuViewController.view.frame.size.width = menuWidth
        menuViewController.view.frame.origin.x = isMenuOpen ? 0 : -menuWidth
        blurView?.frame = containerView.bounds
    }
}
