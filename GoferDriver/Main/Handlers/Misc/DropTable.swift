//
//  DropTable.swift
//  GoferDriver
//
//  Created by trioangle on 31/10/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
import UIKit


class DropDown<T: CustomStringConvertible> :
    NSObject,
    UITableViewDelegate,
    UITableViewDataSource{
    var value : Dynamic<T>
    private var datas : [T] = []
    private var hostView : UIView?
    
    lazy var dropTable : UITableView = {
        let table = UITableView()
        
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = true
        return table
    }()
    let fixHeight : CGFloat = 45
    private let vc : UIViewController
    init(_ vc : UIViewController) {
        self.vc = vc
        self.value = Dynamic<T>()
    }
    func attach(on host : UIView,with datas : [T]) -> Dynamic<T>{
        self.datas = datas
        self.hostView = host
        
        var height = fixHeight * CGFloat(datas.count)
        if height > 450{
            height = 300
        }
        
        let rect = host.convert(host.frame, to: vc.view)
        
        if rect.maxY + height > vc.view.frame.height{
            
            dropTable.frame = CGRect(x: rect.minX,
                                     y: rect.minY - height,
                                     width: rect.width,
                                     height: height)
        }else{
            dropTable.frame = CGRect(x: rect.minX,
                                     y: rect.maxY,
                                     width: rect.width,
                                     height: height)
        }
        vc.view.addSubview(dropTable)
        vc.view.bringSubviewToFront(dropTable)
        dropTable.elevate(8)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.dropTable.reloadData()
        }
        return self.value
    }
    func updateDataSoure(_ datas : [T]){
        self.datas = datas
        self.dropTable.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if( (cell == nil))
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        let data = datas[indexPath.row]
        cell!.textLabel?.text = data.description
        cell?.textLabel?.font = .lightFont(size: 14)
        cell?.textLabel?.textAlignment = .center
        cell?.addAction(for: .tap, Action: {
            [weak self] in
            self?.value.value = data
            self?.dropTable.removeFromSuperview()
        })
        if #available(iOS 12.0, *) {
            let isdarkstyle = self.dropTable.traitCollection.userInterfaceStyle == .dark
            cell?.backgroundColor = isdarkstyle ? .DarkModeBackground : .SecondaryColor
            cell?.contentView.backgroundColor = isdarkstyle ? .DarkModeBackground : .SecondaryColor
        } else {
            // Fallback on earlier versions
        }
        //text =
        return cell!
    }
    func setTheme() {
        if #available(iOS 12.0, *) {
            let isdarkstyle = self.dropTable.traitCollection.userInterfaceStyle == .dark
            self.dropTable.backgroundColor = isdarkstyle ? .DarkModeBackground : .SecondaryColor
        }
        self.dropTable.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.value.value = self.datas[indexPath.row]
        self.dropTable.removeFromSuperview()
    }
}
class Dynamic<T> {
    typealias Listener = (T?) -> Void
    var listener: Listener?
    
    func subscribe(_ listener: Listener?) {
        self.listener = listener
    }
    
    func subscribeAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value : T?{
        didSet {
            listener?(value)
        }
    }
    
    init(_ value : T? = nil) {
        self.value = value
    }
}

