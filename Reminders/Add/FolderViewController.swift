//
//  FolderViewController.swift
//  Reminders
//
//  Created by 이재희 on 2/20/24.
//

import UIKit
import SnapKit
import RealmSwift

class FolderViewController: BaseViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var handler: ((Folder) -> Void)?
    
    let repository = TaskTableRepository()
    lazy var list = repository.fetchFolder()
    
    var folder: Folder?
    lazy var selectedIndex: Int = 0
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        handler?(list[selectedIndex])
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        if let folder = folder {
            if let index = list.firstIndex(where: { $0.id == folder.id }) {
                selectedIndex = index
            }
        }
    }
    
}

extension FolderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "value1Cell")
        
        cell.selectionStyle = .none
        cell.textLabel?.text = list[indexPath.row].title
        cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
}
