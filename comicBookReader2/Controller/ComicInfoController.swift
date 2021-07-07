//
//  ComicBookInfoTableViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class ComicInfoController: UITableViewController {

    // MARK: - Private Properties
    
    // Info Dictionary
    private var info: [String: Any]?
    
    // Array of Info Dictionary Keys
    private var indices: [String]? {
        guard let info = info else { return nil }
        return info.keys.sorted()
    }
    
    // MARK: - LifeCycle Methods
    
    init(data: [String: Any]) {
        super.init(style: .insetGrouped)
        self.info = data
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
    }
    
    // MARK: - TableView DataSource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let indices = indices else { return 0}
        return indices.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let indices = indices else { return nil }
        return indices[section]
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let info = info, let indices = indices else { return cell }
        guard let infoAtCell = info[indices[indexPath.section]] else { return cell }

        cell.textLabel?.text = "\(infoAtCell)"
        return cell
    }
    
}
