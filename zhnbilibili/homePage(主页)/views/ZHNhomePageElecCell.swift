//
//  ZHNhomePageElecCell.swift
//  
//
//  Created by 张辉男 on 17/1/13.
//
//

import UIKit

class ZHNhomePageElecCell: UITableViewCell {

    
    var elecStatusModel: elecModel? {
        didSet {
            
        }
    }
    
    
    // MARK - 懒加载控件
    lazy var elecView: ZHNelecView = {
        let elecView = ZHNelecView.instanceView()
        return elecView
    }()
    
    // MARK - life cycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(elecView)
        self.backgroundColor = kHomeBackColor
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        elecView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func elecCell(tableView: UITableView) -> ZHNhomePageElecCell {
        let classStr = String(describing: ZHNhomePageElecCell.self)
        var cell = tableView.dequeueReusableCell(withIdentifier: classStr)
        if cell == nil {
            cell = ZHNhomePageElecCell(style: .default, reuseIdentifier: classStr)
        }
        return cell as! ZHNhomePageElecCell
    }
}
