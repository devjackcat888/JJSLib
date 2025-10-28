//
//  PopoverMenuTableView.swift
//  HJSwift
//
//  Created by PAN on 2019/1/7.
//  Copyright © 2019 YR. All rights reserved.
//

import Foundation
import UIKit

open class PopoverMenuTableView: UITableView {
    public var selections = [String]() {
        didSet {
            reloadData()
        }
    }

    public var onSelectIndex: ((Int) -> Void)?

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)

        rowHeight = 50
        estimatedRowHeight = 50
        isScrollEnabled = false
        separatorColor = UIColor("#F1F1F1")
        separatorStyle = .none
        dataSource = self
        delegate = self
        register(PopoverMenuTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PopoverMenuTableView: UITableViewDataSource, UITableViewDelegate {
    open override var numberOfSections: Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PopoverMenuTableViewCell {
            cell.titleLabel.text = selections[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectIndex?(indexPath.row)
    }
}

class PopoverMenuTableViewCell: UITableViewCell {
    
    private(set) var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        jjs_setBackgroundColor(.white).jjs_setSelectionStyleNone()
        contentView.jjs_setBackgroundColor(.white)
        titleLabel = UILabel(text: "", font: .systemFont(ofSize: 12), textColor: .black)
            .jjs_layout(superView: contentView, { make in
                make.left.equalTo(10)
                make.centerY.equalToSuperview()
            })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
