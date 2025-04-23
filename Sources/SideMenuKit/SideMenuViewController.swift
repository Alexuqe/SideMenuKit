import UIKit

/// Протокол делегата для отслеживания выбора пункта меню.
public protocol SideMenuDelegate: AnyObject {
    /// Вызывается при выборе пункта меню.
    /// - Parameter index: Индекс выбранного пункта в массиве.
    func didSelect(index: Int)
}

/// UI-компонент бокового меню, отображающий список пунктов меню.
public final class SideMenuViewController: UIViewController {

    /// Делегат для передачи событий выбора пункта меню.
    public weak var delegate: SideMenuDelegate?

    /// Ширина меню.
    private let menuWidth: CGFloat
    /// Тип ячейки для использования в таблице. По умолчанию используется UITableViewCell.
    private let cellType: UITableViewCell.Type
    /// Массив объектов типа `SideMenuItem` для заполнения таблицы.
    private let menuItems: [SideMenuItem]

    /// Таблица для отображения пунктов меню.
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    /// Инициализатор бокового меню.
    ///
    /// - Parameters:
    ///   - menuWidth: Ширина меню. По умолчанию – 40% ширины экрана.
    ///   - cellType: Тип ячейки, используемый в таблице. По умолчанию – `UITableViewCell`.
    ///   - menuItems: Массив объектов `SideMenuItem`, описывающих пункты меню.
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

    /// Требуемый инициализатор для поддержки `NSCoding`. Не реализован.
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Настраивает интерфейс после загрузки представления.
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
    }

    /// Настройка базовых параметров интерфейса.
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

    /// Регистрация ячеек для таблицы.
    private func registerCells() {
        tableView.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
}

// MARK: - UITableView DataSource & Delegate

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {

    /// Возвращает количество строк в секции, равное количеству пунктов меню.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    /// Конфигурирует и возвращает ячейку для индекса.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath)
        configureCell(cell, indexPath: indexPath)
        return cell
    }

    /// Обрабатывает выбор строки таблицы.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(index: indexPath.row)
    }

    /// Настраивает ячейку, заполняя её данными из `menuItems`.
    private func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.imageView?.image = item.image
    }
}
