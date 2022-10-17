//
//  UIImage+Ext.swift
//  Komka
//
//  Created by Evelin Evelin on 17/10/22.
//

import UIKit
import CloudKit

extension UIImage {
    static func changeImageFromURL(baseImage: CKAsset) -> UIImage{
        let imageURL = baseImage.fileURL

        if let url = imageURL,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {

            return image
        }
        return UIImage()
    }
}
