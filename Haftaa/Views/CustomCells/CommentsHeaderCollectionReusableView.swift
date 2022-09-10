//
//  CommentsHeaderCollectionReusableView.swift
//  Haftaa
//
//  Created by Najeh on 28/07/2022.
//

import UIKit

protocol handleDeleteAndReplayProtocol {
    func deleteComment(tag:Int)
    func replayComment(tag:Int)
}

class CommentsHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var btn: UIButton!
    var label = UILabel()
    var containerView = UIView()
    var icon = UIImageView()
    var comment = UILabel()
    var replayButton = UIButton()
    var deleteBtn = UIButton()
    var timeLbl = UILabel()
    var deleteStackV = UIStackView()
    var delegate:handleDeleteAndReplayProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
//
//        addSubview(label)
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
//        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        configureView()
        configureIcon()
        configureUserName()
        configureComment()
        configureDeleteAndTimeLbl()
        configureReplayBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(){
        containerView.backgroundColor = UIColor.lightSkyColor
        containerView.layer.cornerRadius = 15
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5.0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0)
        ])
    }
    
    func configureIcon(){
        icon.image = UIImage(systemName: "person.fill")
        containerView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
            icon.heightAnchor.constraint(equalToConstant: 20.0),
            icon.widthAnchor.constraint(equalToConstant: 20.0),
            icon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0)
        ])
    }
    
    func configureUserName(){
        label.text = "commenter"
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
//            label.heightAnchor.constraint(equalToConstant: 20.0),
//            label.widthAnchor.constraint(equalToConstant: 20.0),
            label.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -5.0)
        ])
    }
    
    func configureComment(){
        comment.text = "commenter"
        comment.numberOfLines = 0
        comment.textAlignment = .right
        containerView.addSubview(comment)
        comment.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            comment.topAnchor.constraint(equalTo: label.topAnchor, constant: 10.0),
            comment.heightAnchor.constraint(equalToConstant: 20.0),
            comment.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5.0),
            comment.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5.0),
            comment.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10.0)
        ])
    }
    
    func configureDeleteAndTimeLbl(){
        deleteBtn.setBackgroundImage(UIImage(named: "delete"), for: .normal)
        
        deleteBtn.isHidden = true
        deleteBtn.addTarget(self, action: #selector(deleteComment(_:)), for: .touchUpInside)
        timeLbl.text = "15 PM"
        deleteStackV.addArrangedSubview(deleteBtn)
        deleteStackV.addArrangedSubview(timeLbl)
        containerView.addSubview(deleteStackV)
        deleteStackV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteStackV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
//            label.heightAnchor.constraint(equalToConstant: 20.0),
//            label.widthAnchor.constraint(equalToConstant: 20.0),
            deleteStackV.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0)
        ])
    }
    
    func configureReplayBtn(){
        replayButton.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        replayButton.addTarget(self, action: #selector(replayComment(_:)), for: .touchUpInside)
        containerView.addSubview(replayButton)
        replayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            replayButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5.0),
            replayButton.heightAnchor.constraint(equalToConstant: 30.0),
            replayButton.widthAnchor.constraint(equalToConstant: 30.0),
            replayButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5.0)
        ])
    }
    
    @objc func deleteComment(_ sender: UIButton){
        self.delegate?.deleteComment(tag: sender.tag)
    }
    
    @objc func replayComment(_ sender: UIButton){
        self.delegate?.replayComment(tag: sender.tag)
    }
}
