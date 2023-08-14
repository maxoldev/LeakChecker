//
//  LeakChecker
//
//  Created by Max Sol on 03.08.2023.
//

import UIKit

// MARK: - Navigation Controller
public final class DebugPanelsNavigationController: UINavigationController, OverlayWindowViewControllerProtocol {

    public override func viewDidLoad() {
        super.viewDidLoad()

#if os(iOS)
        navigationBar.barStyle = .black
#endif
        // Fixes clear background color in iOS 15.
        if #available(iOS 13.0, tvOS 13.0, *) {
#if os(iOS)
            view.backgroundColor = .systemBackground
#endif
            navigationBar.tintColor = .label
        } else {
            navigationBar.tintColor = .black
        }

        if #available(iOS 15, tvOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupActions()
    }

    private func setupActions() {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(close))
        viewControllers.first?.navigationItem.leftBarButtonItem = closeButton
    }

    @objc
    private func close() {
        if let onDismissBlock = onDismissBlock {
            onDismissBlock()
        } else {
            dismiss(animated: true)
        }
    }

    // MARK: - OverlayWindowViewControllerProtocol
    var onDismissBlock: (() -> Void)?

}

// MARK: - Debug Panels List
public enum DebugPanelsListItemAction {
    case showViewControllerOfClass(UIViewController.Type, addAppRelaunchButton: Bool = false)
    case showViewControllerFromBlock(() -> UIViewController, addAppRelaunchButton: Bool = false)
    case performBlock(() -> Void)
}
public typealias DebugPanelsListItem = (title: String, action: DebugPanelsListItemAction)

public final class DebugPanelsListViewController: UITableViewController {

    // MARK: - Private properties
    private let items: [DebugPanelsListItem]

    // MARK: - Init
    public init(items: [DebugPanelsListItem]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }

    // MARK: - Overrides
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch items[indexPath.row].action {
        case let .showViewControllerOfClass(viewControllerClass, addAppRelaunchButton):
            let viewController = viewControllerClass.init()
#if os(iOS)
            if addAppRelaunchButton {
                viewController.addAppRelaunchBarButtonItem()
            }
#endif
            navigationController?.pushViewController(viewController, animated: true)

        case let .showViewControllerFromBlock(viewControllerCreationBlock, addAppRelaunchButton):
            let viewController = viewControllerCreationBlock()
#if os(iOS)
            if addAppRelaunchButton {
                viewController.addAppRelaunchBarButtonItem()
            }
#endif
            navigationController?.pushViewController(viewController, animated: true)

        case let .performBlock(block):
            block()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}
