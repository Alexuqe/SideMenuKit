public protocol SideMenuDelegate: AnyObject {
    func didSelectItem(_ item: any SideMenuItem)
    func menuStateChanged(isOpen: Bool)
}
