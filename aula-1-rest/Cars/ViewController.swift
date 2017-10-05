//
//  ViewController.swift
//  Cars
//
//  Created by Eric.
//  Copyright © 2017 EricBrito. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var ivCars: UIImageView!
    
    
    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if car != nil {
            
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType.rawValue
            title = "Atualizando \(car.name)"
        }
        
        REST.downloadImage(url: "http://lorempixel.com/400/200/technics/3/") { (
            image:UIImage?) in
            
            DispatchQueue.main.async {
                self.ivCars.image = image
            }
        }
    }
    
    @IBAction func saveCar(_ sender: UIButton) {
        
        
        if car == nil{
            let car = Car(brand: tfBrand.text!, name: tfName.text!, price: Double(tfPrice.text!)!, gasType: GasType(rawValue: scGasType.selectedSegmentIndex)!)
    
            REST.saveCar(car){
                (success:Bool) in
                print(success)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
        
            }
            
        }else{
            car.brand = tfBrand.text!
            car.name = tfName.text!
            car.price = Double(tfPrice.text!)!
            car.gasType = GasType(rawValue: scGasType.selectedSegmentIndex)!
            
            REST.updateCar(car){
                (success:Bool) in
                print(success)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            
        
        
        }
    }
}



