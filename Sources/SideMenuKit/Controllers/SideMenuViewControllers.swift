import UIKit

open class SideMenuViewController: UIViewController {
    // MARK: - Properties
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()

    private let items: [SideMenuItemProtocol]
    private let configuration: SideMenuConfiguration

    public weak var delegate: SideMenuDelegate?

    // MARK: - Initialization
    public init(
        items: [SideMenuItemProtocol],
        configuration: SideMenuConfiguration,
        cellType: SideMenuCellProtocol.Type
    ) {
        self.items = items
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
    }

    // MARK: - Setup
    private func setupView() {
        view.backgroundColor = configuration.backgroundColor ?? .systemBackground
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        let cellConfig = configuration.cellConfiguration

        tableView.register(
            cellConfig.cellClass,
            forCellReuseIdentifier: cellConfig.reuseIdentifier
        )

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITableView DataSource & Delegate
extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: configuration.cellConfiguration.reuseIdentifier,
            for: indexPath) as? SideMenuCellProtocol else
        { return UITableViewCell() }

        cell.configure(with: items[indexPath.row])
        return cell as UITableViewCell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.sideMenu(self, didSelectItem: items[indexPath.row])
    }
}
