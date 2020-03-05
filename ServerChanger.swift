//
//  ServerChanger.swift
//
//  Created by Uday on 27/12/19.
//

import UIKit

//MARK:- ServerChanger
class ServerChanger: UIView {

    //MARK:- Private Properties
    private var button              : UIButton!
    private var actions             : [(title: String, url: ServerURLString)] = []
    private lazy var actionSheet    : UIAlertController = {
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }()

    //MARK:- IBInspectables
    @IBInspectable var restartRequired      : Bool = true
    @IBInspectable var hiddenOnProduction   : Bool = true

    //MARK:- Server Change Callback
    var onServerChange: ((ServerURLString)->())?

    //MARK:- init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }

    //MARK:- Private Methods
    private func initialization() {
        button = UIButton(frame: bounds)

        button.backgroundColor                          = .gray
        button.titleLabel?.numberOfLines                = 1
        button.titleLabel?.adjustsFontSizeToFitWidth    = true
        button.titleLabel?.lineBreakMode                = .byWordWrapping
        button.titleLabel?.textAlignment                = .center

        button.setTitle("Change Server", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        addSubview(button)

        #if DEBUG
            isHidden = false
        #else
            isHidden = hiddenOnProduction
        #endif
    }

    @objc private func buttonTapped(_ sender: Any) {
        if onServerChange == nil {
            print("Server Changer: onServerChange closure not implemented. Class may not listen for action clicks.")
        }

        if actionSheet.actions.count == 0 {
            prepareActionSheet()
        }
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            vc.present(actionSheet, animated: false, completion: nil)
        }
    }

    private func prepareActionSheet() {
        for (title, url) in actions {
            let action = UIAlertAction(title: title, style: .default) {
                [weak self] (_) in
                self?.onServerChange?(url)
                self?.saveToUserDefaults(value: url)
                self?.restart()
            }
            actionSheet.addAction(action)
        }

        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action)
    }

    private func restart() {
        guard restartRequired else {return}

        let alertController = UIAlertController(title: "Restart Required", message: "Restart App to see changes", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            exit(0)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            vc.present(alertController, animated: false, completion: nil)
        }
    }

    //MARK:- Public Methods
    func add(title: String, url: ServerURLString) {
        actions.append((title: title, url: url))
    }

    func add<T: RawRepresentable>(urls: [T]) where T.RawValue == ServerURLString {
        urls.forEach({
            actions.append((title: "\($0)", url: $0.rawValue))
        })
    }

    //MARK:- UserDefaults
    private static let userDefaultKey = "SERVERCHANGER_URL"
    private func saveToUserDefaults(value: ServerURLString) {
        UserDefaults.standard.set(value, forKey: ServerChanger.userDefaultKey)
    }
    static var selectedURL: ServerURLString? {
        return UserDefaults.standard.value(forKey: userDefaultKey) as? ServerURLString
    }
}

//MARK:- Protocol
typealias ServerURLString = String

protocol ServerChangerEnum: CaseIterable {}
extension ServerChangerEnum {
    static var allURLs: Self.AllCases {
        get {
            return allCases
        }
    }
}
