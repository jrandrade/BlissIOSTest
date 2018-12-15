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
    var isLoading = false
    var tryLoadMore = false
    var pullToRefresh = false
    
    override func setupView() {
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = NSLocalizedString("search", comment: "")
        
        searchBar.returnKeyType = .done
        
        
        navigationItem.titleView = searchBar
        
        refreshControl.addTarget(self, action: #selector(refreshData(sender:)), for: .valueChanged)
        refreshControl.tintColor = StyleKit.mainColor
        
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
    }
    
    override func loadNibs() {
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
    }
    
    override func setupObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func setupData() {
        isLoading = true
        showLoader()
        
        questionManager.getQuestionList(limit: Config.request.limit, offset: 0, filter: nil) { [weak self] (questions, error) in
            guard let strongSelf = self else {return}
            strongSelf.hideLoader()
            strongSelf.isLoading = false
            strongSelf.refreshControl.endRefreshing()
            strongSelf.pullToRefresh = false
            
            guard error == nil else {
                return
            }
            
            strongSelf.list = questions ?? []
            strongSelf.tableView.reloadData()
        }
    }
    
    func loadMore() {
        isLoading = true
        showLoader()
        
        questionManager.getQuestionList(limit: Config.request.limit, offset: list.count, filter: nil) { [weak self] (questions, error) in
            guard let strongSelf = self else {return}
            strongSelf.hideLoader()
            strongSelf.isLoading = false
            strongSelf.refreshControl.endRefreshing()
            strongSelf.pullToRefresh = false
            
            guard error == nil else {
                return
            }
            
            strongSelf.list.append(contentsOf: questions ?? [])
            strongSelf.tableView.reloadData()
        }
    }
    
    func refreshData(sender: UIRefreshControl) {
        
        tryLoadMore = true
        pullToRefresh = true
        setupData()
    }
    
    @objc func share() {
    }
    
    class func instanciateOnWindow() {
        
        let appDelegate = UIApplication.shared.delegate
        let window = appDelegate?.window
        let inst = self.instantiateNavigation(fromStoryboardName: Config.storyboard.question)
        inst.view.alpha = 0
        window??.rootViewController = inst
        
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [UIViewAnimationOptions.curveLinear], animations: {
            
            inst.view.alpha = 1
        }, completion: nil)
    }

}
//MARK: - UISearchBarDelegate
extension QuestionListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(share))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        isLoading = true
        showLoader()
        
        questionManager.getQuestionList(limit: Config.request.limit, offset: 0, filter: searchText) { [weak self] (questions, error) in
            guard let strongSelf = self else {return}
            strongSelf.hideLoader()
            strongSelf.isLoading = false
            strongSelf.pullToRefresh = false
            
            guard error == nil else {
                return
            }
            
            strongSelf.list = questions ?? []
            strongSelf.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
        searchBar.showsCancelButton = false
        navigationItem.rightBarButtonItem = nil 
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        bottomConstraint.constant = keyboardHeight + 10
        
        let animationDuration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        let animationCurve = userInfo.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as! Double
        
        UIView.animate(withDuration: TimeInterval(exactly: animationDuration)!, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(exactly: animationCurve)!), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let animationDuration = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! Double
        let animationCurve = userInfo.value(forKey: UIKeyboardAnimationCurveUserInfoKey) as! Double
        
        bottomConstraint.constant = 0
        
        UIView.animate(withDuration: TimeInterval(exactly: animationDuration)!, delay: 0, options: UIViewAnimationOptions(rawValue: UInt(exactly: animationCurve)!), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

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
        
        cell.lblTitle.text = list[indexPath.row].question
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == list.count - 1 && tryLoadMore == true && isLoading == false {
            loadMore()
        }
    }
}

