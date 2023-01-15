//
//  UUIMage.swift
//  RNCarPlay
//
//  Created by Alberto Di Mauro on 15/01/23.
//  Copyright © 2023 SOLID Mobile. All rights reserved.
//

import Foundation

@objc extension UIImage
{
    @objc convenience init?(url: URL?) {
          
          guard let url = url,
                let data = try? Data(contentsOf: url)
          else {
              self.init()
              return
          }
           
          self.init(data: data)
      }
    @objc func imageFromBase64(_ base64: String) -> UIImage {
        if let url = URL(string: base64),
           let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

}

