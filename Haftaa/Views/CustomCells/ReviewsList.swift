//
//  ReviewsList.swift
//  Haftaa
//
//  Created by Najeh on 31/07/2022.
//

import UIKit

class ReviewsList: UICollectionViewCell {

    var tableView = UITableView()
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTable()
        // Initialization code
        
    }
    
    func configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReviesCell", bundle: nil), forCellReuseIdentifier: "ReviesCell")
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5.0),
            tableView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0),
            tableView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0),
            tableView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 5.0)
        ])
    }

}

extension ReviewsList:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviesCell", for: indexPath) as! ReviesCell
        return cell
    }
}
