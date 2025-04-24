import UIKit

/// Протокол делегата для отслеживания выбора пункта меню.
public protocol SideMenuDelegate: AnyObject {
    /// Вызывается при выборе пункта меню.
    /// - Parameter index: Индекс выбранного пункта.
    func didSelect(index: Int)
}

/// UI-компонент бокового меню, отображающий список пунктов меню.
public final class SideMenuViewController: UIViewController {

    /// Делегат для передачи событий выбора пункта меню.
    public weak var delegate: SideMenuDelegate?

    /// Ширина меню.
    private let menuWidth: CGFloat
    /// Пользовательский тип ячейки, который регистрируется.
    private let cellType: UITableViewCell.Type
    /// Массив объектов типа SideMenuItem для заполнения таблицы.
    private let menuItems: [SideMenuItem]

    // MARK: Настраиваемые параметры
    /// Цвет фона бокового меню.
    private let backgroundColor: UIColor
    /// Цвет текста в стандартных ячейках.
    private let textColor: UIColor
    /// Цвет фона таблицы.
    private let tableViewColor: UIColor
    /// TintColor для изображений в ячейках.
    private let iconTintColor: UIColor

    /// Таблица для отображения пунктов меню.
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = tableViewColor // задаём цвет фона таблицы
        return tableView
    }()

    /// Инициализатор бокового меню.
    ///
    /// - Parameters:
    ///   - menuWidth: Ширина меню (по умолчанию 40% ширины экрана).
    ///   - cellType: Тип ячейки, используемый в таблице. Если использовать стандартную (UITableViewCell), контент настраивается через contentConfiguration.
    ///   - menuItems: Массив объектов SideMenuItem, описывающих пункты меню.
    ///   - backgroundColor: Цвет фона бокового меню.
    ///   - textColor: Цвет текста в стандартных ячейках.
    ///   - tableViewColor: Цвет фона таблицы.
    ///   - iconTintColor: Цвет изображений (иконок) в стандартных ячейках.
    public init(
        menuWidth: CGFloat = UIScreen.main.bounds.width * 0.4,
        cellType: UITableViewCell.Type = UITableViewCell.self,
        menuItems: [SideMenuItem],
        backgroundColor: UIColor = .darkGray,
        textColor: UIColor = .white,
        tableViewColor: UIColor = .clear,
        iconTintColor: UIColor = .white
    ) {
        self.menuWidth = menuWidth
        self.cellType = cellType
        self.menuItems = menuItems
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.tableViewColor = tableViewColor
        self.iconTintColor = iconTintColor
        super.init(nibName: nil, bundle: nil)
    }

    /// Требуемый инициализатор для поддержки NSCoding.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Жизненный цикл

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
    }

    // MARK: Настройка UI

    private func setupUI() {
        view.backgroundColor = backgroundColor // задаём цвет бокового меню
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    /// Регистрирует тип ячейки для таблицы.
    private func registerCells() {
        tableView.register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }

    // MARK: Приватная настройка стандартной ячейки

    /// Настраивает содержимое стандартной ячейки (UITableViewCell) через UIListContentConfiguration.
    ///
    /// - Parameters:
    ///   - cell: Ячейка, которую требуется настроить.
    ///   - item: Объект типа SideMenuItem, содержащий данные для ячейки.
    /// - Returns: UIListContentConfiguration, настроенный для отображения пункта меню.
    private func contentConfiguration(cell: UITableViewCell, item: SideMenuItem) -> UIListContentConfiguration {
        var content = cell.defaultContentConfiguration()
        // Если у пункта меню есть изображение, используем его; можно также использовать systemName если требуется
        content.image = item.image
        content.imageProperties.preferredSymbolConfiguration = .init(pointSize: 20)
        content.imageToTextPadding = 8
        content.imageProperties.tintColor = .white

        content.attributedText = NSAttributedString(
            string: item.title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .regular),
                .foregroundColor: UIColor.white
            ])
        return content
    }

    /// Конфигурирует ячейку.
    private func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        // Если используется стандартная ячейка, настраиваем её через contentConfiguration;
        // иначе оставляем настройку на усмотрение разработчика.
        if cellType == UITableViewCell.self {
            cell.contentConfiguration = contentConfiguration(cell: cell, item: item)

            cell.backgroundColor = .clear
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true

            let bgView = UIView()
            bgView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            cell.selectedBackgroundView = bgView
        } else {
            // Для кастомных ячеек настройка должна осуществляться в их реализации.
        }
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
}
