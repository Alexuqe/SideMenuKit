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
    /// Тип ячейки для отображения пунктов меню.
    /// Если используется стандартный UITableViewCell, то настройка содержимого производится через contentConfiguration.
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
    /// TintColor для изображений (иконок) в стандартных ячейках.
    private let iconTintColor: UIColor

    /// Таблица для отображения пунктов меню.
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = tableViewColor
        return tableView
    }()

    /// Инициализатор бокового меню.
    ///
    /// - Parameters:
    ///   - menuWidth: Ширина меню (по умолчанию 40% ширины экрана).
    ///   - cellType: Тип ячейки, используемый в таблице. По умолчанию UITableViewCell.
    ///   - menuItems: Массив объектов SideMenuItem, описывающих пункты меню.
    ///   - backgroundColor: Цвет фона бокового меню.
    ///   - textColor: Цвет шрифта в стандартных ячейках.
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

    /// Настраивает интерфейс после загрузки представления.
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCells()
        tableView.reloadData()  // Добавлено для гарантированного обновления контента
    }

    /// Настройка базовых параметров интерфейса.
    private func setupUI() {
        view.backgroundColor = backgroundColor
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

    /// Настраивает содержимое стандартной ячейки (UITableViewCell) через UIListContentConfiguration.
    ///
    /// - Parameters:
    ///   - cell: Ячейка, которую требуется настроить.
    ///   - item: Объект типа SideMenuItem, содержащий данные для ячейки.
    /// - Returns: UIListContentConfiguration, настроенный для отображения пункта меню.
    private func contentConfiguration(cell: UITableViewCell, item: SideMenuItem) -> UIListContentConfiguration {
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.imageProperties.preferredSymbolConfiguration = .init(pointSize: 20)
            content.imageToTextPadding = 8
            content.imageProperties.tintColor = iconTintColor
            content.attributedText = NSAttributedString(
                string: item.title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 20, weight: .regular),
                    .foregroundColor: textColor
                ]
            )
            return content
        } else {
            // Для iOS 13 можно напрямую настроить textLabel и imageView.
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = textColor
            cell.imageView?.image = item.image?.withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = iconTintColor
            return UIListContentConfiguration.cell()  // возвращаем пустую конфигурацию
        }
    }

    /// Конфигурирует ячейку.
    private func configureCell(_ cell: UITableViewCell, indexPath: IndexPath) {
        let item = menuItems[indexPath.row]
        // Если используется стандартная ячейка, настраиваем её через contentConfiguration.
        if cellType == UITableViewCell.self {
            cell.contentConfiguration = contentConfiguration(cell: cell, item: item)

            cell.backgroundColor = .clear
            cell.layer.cornerRadius = 20
            cell.clipsToBounds = true

            let bgView = UIView()
            bgView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            cell.selectedBackgroundView = bgView
        } else {
            // Для кастомных ячеек настройку осуществляет пользовательская реализация.
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
