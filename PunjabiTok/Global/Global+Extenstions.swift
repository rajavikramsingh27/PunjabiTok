

//  Global.swift
//  PunjabiTok
//  Created by GranzaX on 01/06/21.


import Foundation
import UIKit
import MBProgressHUD
import SwiftMessageBar
import Alamofire

// MARK:- Gloabl variables
extension UIViewController {
    func pushToVC(_ storyBoard:String, _ identifier:String, _ animated: Bool) {
        let storyBoard = UIStoryboard (name:storyBoard, bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier:identifier)
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    @IBAction func backVC(_ sender:UIButton) {
        self.navigationController?.popViewController(animated:true)
    }
    
}

//extension UIColor {
//
//    convenience init?(_ hex: String) {
//        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//
//        var rgb: UInt32 = 0
//
//        var r: CGFloat = 0.0
//        var g: CGFloat = 0.0
//        var b: CGFloat = 0.0
//        var a: CGFloat = 1.0
//
//        let length = hexSanitized.count
//
//        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
//
//        if length == 6 {
//            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//            b = CGFloat(rgb & 0x0000FF) / 255.0
//
//        } else if length == 8 {
//            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
//            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
//            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
//            a = CGFloat(rgb & 0x000000FF) / 255.0
//
//        } else {
//            return nil
//        }
//
//        self.init(red: r, green: g, blue: b, alpha: a)
//    }
//
//    // MARK: - Computed Properties
//
//    var toHex: String? {
//        return toHex()
//    }
//
//    // MARK: - From UIColor to String
//
//    func toHex(alpha: Bool = false) -> String? {
//        guard let components = cgColor.components, components.count >= 3 else {
//            return nil
//        }
//
//        let r = Float(components[0])
//        let g = Float(components[1])
//        let b = Float(components[2])
//        var a = Float(1.0)
//
//        if components.count >= 4 {
//            a = Float(components[3])
//        }
//
//        if alpha {
//            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
//        } else {
//            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
//        }
//    }
//
//}

extension UIView {
    func roundTop(_ radius:CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundBottom(radius:CGFloat = 5){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}



extension String {
    func anyConvertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("Bad JSON",error.localizedDescription)
                
            }
        }
        return nil
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func size_According_Text() -> CGSize {
        let constraintRect = CGSize(
            width: UIScreen.main.bounds.width-80,
            height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: UIFont (name: "Verdana", size: 16)!],
            context: nil)
        
        return boundingBox.size
    }
    
    func shortDate_For_Comment() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self)!
        
        let dateFormatter_Check = DateFormatter()
        dateFormatter_Check.dateFormat = "yyyy-MM-dd"
        let strDateCheck = dateFormatter_Check.string(from: date)
        debugPrint(strDateCheck)
        
        let dateFormatter_Check_Today = DateFormatter()
        dateFormatter_Check_Today.dateFormat = "yyyy-MM-dd"
        let strDateCheck_Today = dateFormatter_Check_Today.string(from: Date())
        debugPrint(strDateCheck_Today)
        
        if strDateCheck == strDateCheck_Today {
            dateFormatter.dateFormat = "HH:mm a"
            return "at "+dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "MM dd"
            return "on "+dateFormatter.string(from: date)
        }
    }
    
}


