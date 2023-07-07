//
//  PopupSegue.swift
//  DabangSwift
//
//  Created by young-soo park on 2017. 2. 15..
//  Copyright © 2017년 young-soo park. All rights reserved.
//

import UIKit

class PopupListPopupSegue: UIStoryboardSegue {
    override func perform() {
        let sourceViewController  = self.source
        let destViewController    = self.destination
        
       sourceViewController.present(destViewController, animated:true, completion:nil)
        
    }
}
