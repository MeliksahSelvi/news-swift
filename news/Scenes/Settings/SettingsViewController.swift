//
//  SettingsViewController.swift
//  news
//
//  Created by Melik on 19.05.2025.
//

import UIKit
import StoreKit
import SafariServices

protocol SettingsViewControllerProtocol : AnyObject{
    func didUpdateTheme(mode: Int)
}

class SettingsViewController: UIViewController, SettingsViewControllerProtocol {

    private let viewModel: SettingsViewModelProtocol

    private lazy var settingsTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let versionLabel : UILabel = {
        let label = UILabel()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            label.text = version
        }
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let switchView : UISwitch = UISwitch()
        
    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    
    func didUpdateTheme(mode: Int) {
        switch mode {
        case 1: view.window?.overrideUserInterfaceStyle = .light
        case 2: view.window?.overrideUserInterfaceStyle = .dark
        default: view.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
    
}

private extension SettingsViewController {
    
    func buildViews(){
        view.backgroundColor = .systemGray6
        addViews()
        buildConstraints()
    }
    
    func addViews(){
        view.addSubview(settingsTableView)
        view.addSubview(versionLabel)
    }
    
    func buildConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        constraints.append(settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(settingsTableView.topAnchor.constraint(equalTo: view.topAnchor))
        
        constraints.append(versionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16))
        constraints.append(versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}

extension SettingsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let section = self.viewModel.getSections()[indexPath.section]
        let item = section.items[indexPath.row]
        
        cell.tintColor = .label
        cell.textLabel?.text = item.title
        cell.textLabel?.textAlignment = .natural
        cell.textLabel?.textColor = .label
        cell.imageView?.image = UIImage(systemName: item.iconName)
        
        switch item.type {
        case .theme:
            let items = ["Settings.autoMode".localized,"Settings.lightMode".localized, "Settings.darkMode".localized]
            let segmentedControl = UISegmentedControl(items: items)
            segmentedControl.selectedSegmentIndex = self.viewModel.getSelectedSegmentControlIndex()
            segmentedControl.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
            segmentedControl.translatesAutoresizingMaskIntoConstraints = false
            cell.accessoryView = segmentedControl
        case .notification:
            viewModel.updateNotificationSwitch { isAuthorized in
                self.switchView.isOn = isAuthorized
            }
            switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            switchView.translatesAutoresizingMaskIntoConstraints = false
            cell.accessoryView = switchView
        case .privacyPolicy, .rateApp , .termOfUse:
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.getSections()[indexPath.section].items[indexPath.row]
        didSelectItem(item: item)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getSections()[section].items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.getSections().count
    }
}


@objc private extension SettingsViewController {
    
    func themeChanged(_ sender: UISegmentedControl) {
        viewModel.updateThemeMode(sender.selectedSegmentIndex)
    }
    
    func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            viewModel.requestNotificationPermission {
                sender.isOn = $0
            }
        } else {
            goToSettingsToDisableNotification()
        }
    }
    
    func appDidBecomeActive() {
        viewModel.updateNotificationSwitch{ isAuthorized in
            self.switchView.isOn = isAuthorized
        }
    }
}

private extension SettingsViewController  {
    
    func goToSettingsToDisableNotification() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
            
        }
    }
    
    func didSelectItem(item: SettingsItem){
        switch item.type {
        case .rateApp: promptForReview()
        case .privacyPolicy: openUrl("https://www.google.com/")
        case .termOfUse: openUrl("https://www.google.com/")
        default : break
        }
    }
    
    func promptForReview() {
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func openUrl(_ url: String){
        guard let urlToOpen = URL(string: url) else { return }
        let safariVC = SFSafariViewController(url: urlToOpen)
        safariVC.modalPresentationStyle = .overFullScreen
        present(safariVC, animated: true)
    }
}

 #Preview {
     let viewModel : SettingsViewModelProtocol = PreviewSettingsViewModel()
     SettingsViewController(viewModel: viewModel)
 }
