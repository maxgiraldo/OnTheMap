//
//  TextField.swift
//  OnTheMap
//
//  Created by Maximilian A. Giraldo on 10/23/15.
//  Copyright © 2015 Maximilian A. Giraldo. All rights reserved.
//

import UIKit

class TextField: UITextField {
  
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 10, 10);
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 10, 10);
  }

}
