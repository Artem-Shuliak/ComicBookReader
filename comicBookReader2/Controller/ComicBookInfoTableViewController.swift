//
//  ComicBookInfoTableViewController.swift
//  comicBookReader2
//
//  Created by readdle on 06.07.2021.
//

import UIKit

class ComicBookInfoTableViewController: UITableViewController {

    var info: [String: Any]?
    
    var indices: [String]? {
        guard let info = info else { return nil }
        return info.keys.sorted()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func populateWithData(data: [String: Any]) {
        self.info = data
        tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let indices = indices else { return 0}
        return indices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let info = info, let indices = indices else { return cell }
        guard let infoAtCell = info[indices[indexPath.row]] else { return cell }
        
        cell.textLabel?.text = infoAtCell as? String
        return cell
    }

}
