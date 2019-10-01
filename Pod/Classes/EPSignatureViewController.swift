//
//  EPSignatureViewController.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 13/01/16.
//
//

import UIKit

    // MARK: - EPSignatureDelegate
@objc public protocol EPSignatureDelegate {
    @objc optional    func epSignature(_: EPSignatureViewController, didCancel error : NSError)
    @objc optional    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect)
}

open class EPSignatureViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var viewMargin: UIView!
    @IBOutlet weak var lblX: UILabel!
    @IBOutlet weak var signatureView: EPSignatureView!
    @IBOutlet var signatureViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var backgroundSignatureView: UIView!
    // MARK: - Public Vars
    
    open var showsDate: Bool = true
    open var showsSaveSignatureOption: Bool = true
    open weak var signatureDelegate: EPSignatureDelegate?
    open var subtitleText = "Sign Here"
    open var tintColor = UIColor.defaultTintColor()

    // MARK: - Life cycle methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        self.backgroundSignatureView.layer.borderWidth = 1
        self.backgroundSignatureView.layer.borderColor = UIColor.black.cgColor
        self.signatureViewHeightConstraint.constant = min(self.view.frame.width * 0.9, self.view.frame.height * 0.9)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(EPSignatureViewController.onTouchCancelButton))
        cancelButton.tintColor = tintColor
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(EPSignatureViewController.onTouchDoneButton))
        doneButton.tintColor = tintColor
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(EPSignatureViewController.onTouchClearButton))
        clearButton.tintColor = tintColor

        self.navigationItem.rightBarButtonItems = [doneButton, clearButton]
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Initializers
    
    public convenience init(signatureDelegate: EPSignatureDelegate) {
        self.init(signatureDelegate: signatureDelegate, showsDate: true, showsSaveSignatureOption: true)
    }
    
    public convenience init(signatureDelegate: EPSignatureDelegate, showsDate: Bool) {
        self.init(signatureDelegate: signatureDelegate, showsDate: showsDate, showsSaveSignatureOption: true)
    }
    
    public init(signatureDelegate: EPSignatureDelegate, showsDate: Bool, showsSaveSignatureOption: Bool ) {
        self.showsDate = showsDate
        self.showsSaveSignatureOption = showsSaveSignatureOption
        self.signatureDelegate = signatureDelegate
        let bundle = Bundle(for: EPSignatureViewController.self)
        super.init(nibName: "EPSignatureViewController", bundle: bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    
    @objc func onTouchCancelButton() {
        signatureDelegate?.epSignature!(self, didCancel: NSError(domain: "EPSignatureDomain", code: 1, userInfo: [NSLocalizedDescriptionKey:"User not signed"]))
        dismiss(animated: true, completion: nil)
    }

    @objc func onTouchDoneButton() {
        if let signature = signatureView.getSignatureAsImage() {
            signatureDelegate?.epSignature!(self, didSign: signature, boundingRect: signatureView.getSignatureBoundsInCanvas())
            dismiss(animated: true, completion: nil)
        } else {
            showAlert("You did not sign", andTitle: "Please draw your signature")
        }
    }
    
    @objc func onTouchActionButton(_ barButton: UIBarButtonItem) {
        let action = UIAlertController(title: "Action", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        action.view.tintColor = tintColor
        
        action.addAction(UIAlertAction(title: "Load default signature", style: UIAlertAction.Style.default, handler: { action in
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
            self.signatureView.loadSignature(filePath)
        }))
        
        action.addAction(UIAlertAction(title: "Delete default signature", style: UIAlertAction.Style.destructive, handler: { action in
            self.signatureView.removeSignature()
        }))
        
        action.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        if let popOver = action.popoverPresentationController {
            popOver.barButtonItem = barButton
        }
        present(action, animated: true, completion: nil)
    }

    @objc func onTouchClearButton() {
        signatureView.clear()
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signatureView.reposition()
    }
}
