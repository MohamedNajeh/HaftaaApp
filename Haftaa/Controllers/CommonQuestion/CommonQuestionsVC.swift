//
//  CommonQuestionsVC.swift
//  Haftaa
//
//  Created by Najeh on 21/05/2022.
//

import UIKit

class CommonQuestionsVC: UIViewController,UISheetPresentationControllerDelegate{

    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    @IBOutlet weak var tableView: UITableView!
    var question:[CommonQ] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        configureSheet()
        fetchQuestions()
        // Do any additional setup after loading the view.
    }
    func fetchQuestions(){
        showLoadingView()
        NetworkManager.shared.fetchData(url: "get_questions", decodable: CommonQestions.self) { response in
            self.removeLoadingView()
            switch response {
            case .success(let questions):
                guard let questions = questions.data else {return}
                self.question = questions
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func configureSheet(){
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [.medium(),.large()]
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommomQuestionCell", bundle: nil), forCellReuseIdentifier: "QCell")
    }
}

extension CommonQuestionsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QCell", for: indexPath) as! CommomQuestionCell
        cell.questionLbl.text = question[indexPath.row].question
        cell.answerLbl.attributedText = question[indexPath.row].answer?.htmlToAttributedString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

