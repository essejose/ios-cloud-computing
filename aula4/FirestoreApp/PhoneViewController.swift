//
//  PhoneViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {

    @IBOutlet weak var tfModel: UITextField!
    @IBOutlet weak var tfManufacture: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfYear: UITextField!

    
    var phone : Phone!
    
    lazy var firestore : Firestore = {
        
        let store = Firestore.firestore()
        return store
        
    }()
    
    @IBAction func save(_ sender: UIButton) {
        
        var phoneDict: [String : Any] = [:]
        
 
        
        
        phoneDict["model"] = tfModel.text!
        phoneDict["manufacture"] = tfManufacture.text!
        phoneDict["price"] = Double(tfPrice.text!)!
        phoneDict["year"] = Double(tfYear.text!)!
        
        
        if phone == nil{
            
            firestore.collection("phones").addDocument(data: phoneDict){ (error: Error?) in
                self.navigationController!.popViewController(animated: true)
                
            }
        
        }else{
            
            
            firestore.collection("phones").document(phone.id).setData(phoneDict, completion: { (error: Error?) in
                self.navigationController!.popViewController(animated: true)

            })
        
            
            
        }
        
     
        
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        if phone != nil {
            
            tfModel.text  = phone.model
            tfManufacture.text = phone.manufacture
            tfPrice.text = "\(phone.price)"
            tfYear.text = "\(phone.year)"
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
