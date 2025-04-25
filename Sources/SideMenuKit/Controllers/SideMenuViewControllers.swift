import UIKit

final class SideMenuViewController: UIViewController {
    private var configuration: SideMenuConfiguration
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    var didSelectItem: ((Int) -> Void)?

    init(configuration: SideMenuConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.backgroundColor = configuration.appearance.menuBackgroundColor
    }

    func updateConfiguration(_ newConfig: SideMenuConfiguration) {
        configuration = newConfig
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        let cellType = configuration.cellType ?? DefaultSideMenuCell.self
        tableView.register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)

        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        configuration.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: configuration.cellType?.reuseIdentifier ?? DefaultSideMenuCell.reuseIdentifier,
            for: indexPath
        ) as! SideMenuCellProtocol

        cell.configure(with: configuration.items[indexPath.row])
        return cell as UITableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectItem?(indexPath.row)
    }
}
