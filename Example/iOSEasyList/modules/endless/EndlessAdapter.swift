//
//  EndlessAdapter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/12/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class EndlessAdapter: TableViewAdapter {
    
    weak var delegate:EndlessAdapterDelegate?
    private var storedOffsets = [Int: CGFloat]()
   
    
    override init(tableView: UITableView) {
        super.init(tableView: tableView)
        
        self.configCell = { (tableView, index, data) in
            if let movie = data as? Movie{
                
                //hero cell
                if index.row % 10 == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: HeroCell.reuseIdentifier, for: index) as! HeroCell
                    cell.data = movie
                    return cell
                }
                    
                    //movie cell
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier, for: index) as! MovieCell
                    cell.data = movie
                    return cell
                }
                
            }
                
                //popularCell
            else{
                let popular = data as! PopularMovies
                
                let cell = tableView.dequeueReusableCell(withIdentifier: PopularCell.reuseIdentifier, for: index) as! PopularCell
                cell.data = popular
                cell.collectionViewOffset = self.storedOffsets[index.row] ?? 0
                return cell
            }
        }
        
        animationConfig = AnimationConfig(reload: .none, insert: .fade, delete: .none)
    }
    
    func setData(newData: [Any]) {
        guard let tableView = tableView else { return  }
        super.setData(newData: newData, animated: !tableView.isEmpty)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let popularCell = cell as? PopularCell else { return }
        
        storedOffsets[indexPath.row] = popularCell.collectionViewOffset
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       delegate?.scrollViewDidScroll(scrollView: scrollView)
    }
}

protocol EndlessAdapterDelegate:class {
    func scrollViewDidScroll(scrollView: UIScrollView)
}
