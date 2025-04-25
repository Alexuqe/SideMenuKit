# SideMenuKit

**SideMenuKit** – это легковесная Swift Package-библиотека для быстрого создания настраиваемого бокового меню в iOS-приложениях. С SideMenuKit вы можете:

- Быстро интегрировать меню в ваш проект.
- Насраивать ширину меню.
- Использовать как стандартные, так и кастомные ячейки для отображения пунктов меню.
- Централизованно управлять навигацией между экранами с помощью роутера.

## Особенности

- **Динамическая настройка ширины меню:** задавайте нужную ширину при инициализации.
- **Кастомизация ячеек:** используйте стандартные `UITableViewCell` или свой тип ячейки (через параметр `cellType`).
- **Анимированное появление/скрытие меню:** плавные анимации, выполняемые на главном акторе, чтобы обеспечить безопасное обновление UI.
- **Централизованная навигация:** переключение между экранами посредством `SideMenuRouter`, который принимает массив `UIViewController`.
- **Требования:** iOS 13.0+, Swift 6.0+, Xcode 14+.

## Установка

### Swift Package Manager (SPM)

1. Откройте ваш проект в Xcode.
2. Выберите **File > Add Packages…**
3. Введите URL репозитория вашего SideMenuKit, например:
"https://github.com/your_username/SideMenuKit.git"
4. Выберите нужную версию и нажмите **Add Package**.
5. В нужных файлах импортируйте модуль:

```swift
import SideMenuKit
```

## Структура проекта
```swift
SideMenuKit/
├── Package.swift                # Конфигурация Swift Package
└── Sources/
    └── SideMenuKit/
        ├── SideMenuItem.swift   # Модель данных для пункта меню
        ├── SideMenuViewController.swift   # UI-компонент бокового меню
        ├── SideMenuManager.swift  # Менеджер для отображения/скрытия меню
        └── SideMenuRouter.swift   # Централизованная навигация между экранами
```

## Использование

### 1. SideMenuItem
Используйте SideMenuItem для описания пункта меню. Пример:
```swift
let item = SideMenuItem(title: "Главная", image: UIImage(named: "home_icon"))
```

### 2. SideMenuViewController
Создайте экземпляр бокового меню, передав ширину, тип ячейки (опционально) и массив данных:
```swift
let menuItems: [SideMenuItem] = [
    SideMenuItem(title: "Главная", image: UIImage(named: "home_icon")),
    SideMenuItem(title: "Профиль", image: UIImage(named: "profile_icon")),
    SideMenuItem(title: "Настройки", image: UIImage(named: "settings_icon")),
    SideMenuItem(title: "Выход", image: UIImage(named: "logout_icon"))
]

// Использование стандартной ячейки (UITableViewCell)
let sideMenuVC = SideMenuViewController(menuWidth: 300, cellType: UITableViewCell.self, menuItems: menuItems)
```

### 3. SideMenuManager
Класс SideMenuManager отвечает за анимированное появление и скрытие меню:
```swift
 let menuManager = SideMenuManager(
            container: self,
            navigationVC: navigationVC,
            blurEffectView: blurEffectView,
            menuWidth: 300,
            menuItems: menuItems
        )
        
menuManager.showMenu()

Чтобы скрыть меню, вызовите:
menuManager.hideMenu()
```

### 4. SideMenuRouter
SideMenuRouter обеспечивает централизованную навигацию между экранами. Передайте ему массив контроллеров для переключения:
```swift
let viewControllers: [UIViewController] = [
    HomeViewController(),
    ProfileViewController(),
    SettingsViewController(),
    LogoutViewController()
]

let router = SideMenuRouter(container: self, controllers: viewControllers)
router.navigate(to: 0)  // Переход на экран по индексу 0 (например, HomeViewController)
```

## Пример интеграции
Ниже приведён пример контейнерного контроллера, демонстрирующего, как использовать SideMenuKit для интеграции бокового меню и навигации между экранами:
```swift
import UIKit
import SideMenuKit

/// Контейнерный контроллер, в котором интегрируется боковое меню и осуществляется навигация между экранами.
final class ContainerViewController: UIViewController {

    // Массив данных меню.
    private let menuItems: [SideMenuItem] = [
        SideMenuItem(title: "Главная", image: UIImage(named: "home_icon")),
        SideMenuItem(title: "Профиль", image: UIImage(named: "profile_icon")),
        SideMenuItem(title: "Настройки", image: UIImage(named: "settings_icon")),
        SideMenuItem(title: "Выход", image: UIImage(named: "logout_icon"))
    ]
    
    // Массив контроллеров для навигации.
    private var viewControllers: [UIViewController] = [
        HomeViewController(),
        InfoViewController(),
        RatingViewController()
    ]
    
    // Менеджер бокового меню с расширенной анимацией.
    private var menuManager: SideMenuManager!
    
    // Роутер для переключения между экранами.
    private var menuRouter: SideMenuRouterProtocol!
    
    // Свойства, необходимые для расширенной анимации.
    // Предполагается, что контейнер обернут в UINavigationController.
    private var navigationVC: UINavigationController? {
        return self.navigationController
    }
    
    // Blur Effect View для эффекта размытия фона.
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame = self.view.bounds
        view.alpha = 0.0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        // Добавляем blurEffectView в иерархию и отправляем его назад.
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
        
        // Инициализируем менеджер бокового меню с расширенной анимацией.
        menuManager = SideMenuManager(
            container: self,
            navigationVC: navigationVC,
            blurEffectView: blurEffectView,
            menuWidth: 300,
            menuItems: menuItems
        )
        
        // Инициализируем роутер, который осуществляет навигацию между контроллерами.
        menuRouter = SideMenuRouter(container: self, controllers: viewControllers)
        
        // Настраиваем кнопку вызова меню в navigation bar.
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.dash"),
            style: .done,
            target: self,
            action: #selector(didTapMenuButton)
        )
    }
    
    /// Вызывает показ бокового меню с обновленной анимацией.
    @objc private func didTapMenuButton() {
        menuManager.showMenu()
    }
}

extension ContainerViewController: SideMenuDelegate {
    /// Реализация делегата меню: при выборе пункта скрываем меню и переключаем экран.
    func didSelect(index: Int) {
        menuManager.hideMenu()
        menuRouter.navigate(to: index)
    }
}
```

## Кастомизация
- Ширина меню: Передавайте нужное значение menuWidth в инициализатор SideMenuManager или SideMenuViewController.

- Кастомные ячейки: Если хотите использовать свой компонент ячейки, передайте его тип через параметр cellType при создании бокового меню. Убедитесь, что
ваша ячейка корректно конфигурируется (например, реализуйте метод configure(with:)).

- Данные меню: Заполните массив SideMenuItem нужными заголовками и изображениями.


## Лицензия
Этот проект распространяется под лицензией MIT License.
