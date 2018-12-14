//
//  QuestionListViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 14/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class QuestionListViewController: BasicViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var searchBar: UISearchBar!
    private let refreshControl = UIRefreshControl()
    var list = [Question]()
    lazy var questionManager = QuestionManager()
    
    override func setupView() {
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        searchBar.returnKeyType = .done
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = StyleKit.grayText
        navigationItem.titleView = searchBar
        
        refreshControl.addTarget(self, action: #selector(setupData), for: .valueChanged)
        refreshControl.tintColor = StyleKit.mainColor
        
        tableView.refreshControl = refreshControl
    }
    
    override func loadNibs() {
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
    }
    
    override func setupData() {
        questionManager.getQuestionList(limit: Config.request.limit, offset: 0, filter: nil) { [weak self] (questions, error) in
            guard let strongSelf = self else {return}
            
            guard error == nil else {
                return
            }
            
            strongSelf.list = questions ?? []
            strongSelf.tableView.reloadData()
        }
    }

}
//MARK: - UISearchBarDelegate
extension QuestionListViewController: UISearchBarDelegate {
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension QuestionListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else {
            return UITableViewCell()
        }
        
        
    }
}
