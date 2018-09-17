//
//  ProjectBar.swift
//  ColorKit-Swift
//
//  Created by Dixi-Chen on 2018/9/16.
//  Copyright © 2018 Dixi-Chen. All rights reserved.
//

import UIKit

class ProjectBar: UIView {

    @IBOutlet weak var badgeImageView: UIImageView!
  
     @IBOutlet weak var nameLabel: UILabel!
    
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setProject(_ project:Project){
        badgeImageView.image = UIImage(named: project.badgeName ?? "badge_game")
        nameLabel.text = project.name ?? ""
    }
}
