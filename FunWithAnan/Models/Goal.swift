//
//  Goal.swift
//  FunWithAnan
//
//  Created by Test2 on 20/06/2022.
//

import Foundation
import UIKit

class GoalView: UIView {
    override func draw(_ rect: CGRect) {
        let image = UIImage(named: "goalImage")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        self.addSubview(imageView)
    }
}
