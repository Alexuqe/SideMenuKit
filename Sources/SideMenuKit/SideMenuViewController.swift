import UIKit

public protocol SideMenuDelegate: AnyObject {
    func didSelect(index: Int)
}

public final class SideMenuViewController: UIViewController {

    public weak var delegate: SideMenuDelegate?
    private let menuWidth: CGFloat
    private let cellType: UITableViewCell.Type
    private let menuItems: [SideMenuItem]

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    public init(
        menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4,
        cellType: UITableViewCell.Type = UITableViewCell.self,
        menuItems: [SideMenuItem]
    ) {
        self.menuWidth = menuWidth
        self.cellType = cellType
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
    }

    private func setupUI() {
        view.backgroundColor = .darkGray
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func registerCells() {
        tableView.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(index: indexPath.row)
    }

    private func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.imageView?.image = item.image
    }
}
