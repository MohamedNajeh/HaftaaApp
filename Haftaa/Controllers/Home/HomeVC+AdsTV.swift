//
//  HomeVC+AdsTV.swift
//  Haftaa
//
//  Created by Najeh on 03/05/2022.
//

import Foundation
import UIKit
extension HomeVC:UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,locationAndDetailsActions{
    func locationPressed(tag: Int) {
        print("location")
        if isSearching {
            if filterdAdds[tag].lat == "0" || filterdAdds[tag].lng == "0"{
                print("Not location")
                let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "AddsInCity") as! AddsInCity
                vc.cityID = filterdAdds[tag].city?.id ?? 0
                vc.title = filterdAdds[tag].city?.name
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.openLoaction(lat: filterdAdds[tag].lat ?? "", lng: filterdAdds[tag].lat ?? "")
            }
        }else if isTypeFilter{
            if filterdByType[tag].lat == "0" || filterdByType[tag].lng == "0"{
                print("Not location")
                let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "AddsInCity") as! AddsInCity
                vc.cityID = filterdByType[tag].city?.id ?? 0
                vc.title = filterdByType[tag].city?.name
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.openLoaction(lat: filterdByType[tag].lat ?? "", lng: filterdByType[tag].lat ?? "")
            }
        }
        if allAds[tag].lat == "0" || allAds[tag].lng == "0"{
            print("Not location")
            let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "AddsInCity") as! AddsInCity
            vc.cityID = allAds[tag].city?.id ?? 0
            vc.title = allAds[tag].city?.name
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.openLoaction(lat: allAds[tag].lat ?? "", lng: allAds[tag].lat ?? "")
        }
        
    }
    
    func detailsPressed(tag: Int) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "UserDetailsVC") as! UserDetailsVC
        if isSearching {
            vc.userDetails = filterdAdds[tag].user
            vc.title = filterdAdds[tag].user?.name
        }else if isTypeFilter{
            vc.userDetails = filterdByType[tag].user
            vc.title = filterdByType[tag].user?.name
        }else{
            vc.userDetails = allAds[tag].user
            vc.title = allAds[tag].user?.name
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filterdAdds.count
        }
        if isTypeFilter {
            return filterdByType.count
        }
        return allAds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adsCell", for: indexPath) as! adsCell
        cell.delegate = self
        cell.locationBtn.tag = indexPath.row
        cell.userDtailBtn.tag = indexPath.row
        if isSearching {
            if filterdAdds[indexPath.row].isType ?? false {
                cell.configureCell(isLast: true, add: filterdAdds[indexPath.row])
                return cell
            }else{
                cell.configureCell(isLast: false, add: filterdAdds[indexPath.row])
                if filterdAdds[indexPath.row].lat == "0" || filterdAdds[indexPath.row].lng == "0"{
                    cell.countryLbl.text = filterdAdds[indexPath.row].city?.name ?? ""
                }else{
                    cell.countryLbl.text = filterdAdds[indexPath.row].distance
                }
                
                if filterdAdds[indexPath.row].user?.trusted == 1 {
                    cell.userIcon.image = UIImage(named: "verify")
                }else{
                    cell.userIcon.image = UIImage(systemName: "person.fill")
                }
                return cell
            }
        }
        else if isTypeFilter {
            if filterdByType[indexPath.row].isType ?? false {
                cell.configureCell(isLast: true, add: filterdByType[indexPath.row])
                return cell
            }else{
                cell.configureCell(isLast: false, add: filterdByType[indexPath.row])
                if filterdByType[indexPath.row].lat == "0" || filterdByType[indexPath.row].lng == "0"{
                    cell.countryLbl.text = filterdByType[indexPath.row].city?.name ?? ""
                }else{
                    cell.countryLbl.text = filterdByType[indexPath.row].distance
                }
                if filterdByType[indexPath.row].user?.trusted == 1 {
                    cell.userIcon.image = UIImage(named: "verify")
                }else{
                    cell.userIcon.image = UIImage(systemName: "person.fill")
                }
                return cell
            }
        }
        
         if allAds[indexPath.row].isType ?? false {
            cell.configureCell(isLast: true, add: allAds[indexPath.row])
            return cell
        }else{
            cell.configureCell(isLast: false, add: allAds[indexPath.row])
            
            if allAds[indexPath.row].lat == "0" || allAds[indexPath.row].lng == "0"{
                cell.countryLbl.text = allAds[indexPath.row].city?.name ?? ""
            }else{
                cell.countryLbl.text = allAds[indexPath.row].distance
            }
            let id = (allAds[indexPath.row].user?.id) ?? 0
            if (onlineUsersIds.contains(id) ){
                cell.onlineView.backgroundColor = .green
            }else{
                cell.onlineView.backgroundColor = .red
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "AdsDetails", bundle: nil).instantiateViewController(withIdentifier: "adsDetailsVC") as! adsDetailsVC
        if isSearching {
            //vc.details = filterdAdds[indexPath.row]
            if filterdAdds[indexPath.row].isType ?? false {
                
            }else{
                vc.addID = filterdAdds[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if isTypeFilter{
            //vc.details = filterdByType[indexPath.row]
            if filterdByType[indexPath.row].isType ?? false {
                
            }else{
                vc.addID = filterdByType[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            //vc.details = allAds[indexPath.row]
            if allAds[indexPath.row].isType ?? false {
                
            }else{
                vc.addID = allAds[indexPath.row].id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        if searchText.count > 0 {
            isSearching = true
            var result:[AddsDetails] = []
            if isTypeFilter {
                for add in filterdByType {
                    if ((add.title?.containsIgnoringCase(searchText)) != nil) {
                        result.append(add)
                    }
                }
            }else{
                
                for add in allAds {
                    if add.title!.containsIgnoringCase(searchText) {
                        result.append(add)
                    }
                }
            }
            filterdAdds = result
            adsTableView.reloadData()
        }
        else {
            isSearching = false
            adsTableView.reloadData()
        }
        //let newText = (oldText as NSString).replacingCharacters(in: range, with: string)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = 0
        let lastRowIndex = allAds.count - 1

        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && page <= totalPages{
            page += 1
            self.fetchAllads(page: page)
        }
    }
    
    
    @objc func openLoaction(lat:String,lng:String)
    {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(lng)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
}
