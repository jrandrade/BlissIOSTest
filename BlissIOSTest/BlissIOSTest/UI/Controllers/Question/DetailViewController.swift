//
//  DetailViewController.swift
//  BlissIOSTest
//
//  Created by Jorge Andrade on 15/12/2018.
//  Copyright © 2018 Jorge Andrade. All rights reserved.
//

import UIKit

class DetailViewController: BasicViewController {

    @IBOutlet weak var imgQuestion: UIImageView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPublishedAt: UILabel!
    
    lazy var questionManager = QuestionManager()
    
    var question: Question? = nil
    var selectedIndex: Int? = nil
    
    override func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "share"), style: .plain, target: self, action: #selector(share))
        
        title = NSLocalizedString("question", comment: "")
        guard let question = question else {return}
        
        if let url = question.image_url {
            imgQuestion.setImage(withUrl: url, placeholder: #imageLiteral(resourceName: "bliss-applications"))
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        let date = dateFormatter.date(from: question.published_at ?? "")
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        lblPublishedAt.text = dateFormatter.string(from: date ?? Date())
        lblQuestion.text = question.question
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    override func loadNibs() {
        tableView.register(UINib(nibName: "ChoiceTableViewCell", bundle: nil), forCellReuseIdentifier: "ChoiceTableViewCell")
    }
    
     func showSuccessAlert() {
        let alert = UIAlertController(title: NSLocalizedString("success", comment: ""), message: NSLocalizedString("tanks_for_voting", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: UIAlertActionStyle.default, handler: { [weak self]  action in
            guard let strongSelf = self else {return}
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
     func showErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: NSLocalizedString("error_description", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("try_again", comment: ""), style: UIAlertActionStyle.default, handler: { [weak self]  action in
            guard let strongSelf = self else {return}
            if let question = strongSelf.question, let choice = question.choices?[strongSelf.selectedIndex ?? 0] {
                
                choice.votes = (choice.votes ?? 0) + 1
                
                strongSelf.showLoader()
                strongSelf.questionManager.updateQuestion(question, result: {[weak self] (updatedQuestion, error) in
                    guard let strongSelf = self else {return}
                    
                    guard error == nil else {
                        strongSelf.hideLoader()
                        strongSelf.showErrorAlert()
                        return
                    }
                    
                    strongSelf.question = updatedQuestion
                    strongSelf.tableView.reloadData()
                })
            }

        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertActionStyle.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func share() {
        if let vc = ShareViewController.instantiate(fromStoryboardName: Config.storyboard.question) as? ShareViewController {
            vc.id = question?.id
            vc.isDetail = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question?.choices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceTableViewCell") as? ChoiceTableViewCell else {
            return UITableViewCell()
        }
        
        cell.lblChoice.text = "\(question?.choices?[indexPath.row].choice ?? "") - \(question?.choices?[indexPath.row].votes ?? 0) votes"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ChoiceTableViewCell {
            cell.setSelectedLayout()
        }
        
        if let question = question, let choice = question.choices?[indexPath.row] {
            
            choice.votes = (choice.votes ?? 0) + 1
            selectedIndex = indexPath.row
            
            showLoader()
            questionManager.updateQuestion(question, result: {[weak self] (updatedQuestion, error) in
                guard let strongSelf = self else {return}
                strongSelf.hideLoader()
                guard error == nil else {
                    strongSelf.showErrorAlert()
                    return
                }
                strongSelf.showSuccessAlert()
                strongSelf.question = updatedQuestion
                strongSelf.tableView.reloadData()
            })
        }
    }
}
