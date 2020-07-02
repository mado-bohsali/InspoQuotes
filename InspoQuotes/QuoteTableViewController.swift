//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver { //Publisher - Observer
    
    
    let productID = "com.meb1995.InspoQuotes.AllQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        SKPaymentQueue.default().add(self)
        
        if UserDefaults.standard.data(forKey: productID) == Data(base64Encoded: "Purchased") {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotesToShow.count+1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        // Configure the cell...
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0
        } else {
            //Get more quotes
            cell.textLabel?.text = "Get More Quotes"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .magenta
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func buyPremiumQuotes(){
        //queue of payment transactions to be processed
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment() //mutable request to the App Store to process payment
            paymentRequest.productIdentifier = productID
            
            
            SKPaymentQueue.default().add(paymentRequest)
        }
    }
    
    /*
         An observer is called when transactions are updated by the queue or removed from the queue.
         An observer should process all successful transactions, unlock the functionality purchased by the user,
         and then finish the transaction by calling the payment queue’s finishTransaction(_:) method.
     */
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            switch transaction.transactionState {
            case .deferred:
                print("final status is pending")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                print("transaction failed")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .purchased:
                print("transaction successful")
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction) //Notifies the App Store that the app finished processing the transaction
                
                UserDefaults.standard.setValue("Purcashed", forKey: productID)
                
            case .purchasing:
               print("being processed by the App Store")
               SKPaymentQueue.default().finishTransaction(transaction)
                
            case .restored:
                print("restores content previously purchased by the user")
                SKPaymentQueue.default().finishTransaction(transaction)
            
            default:
                print("Overall process is under construction")
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func showPremiumQuotes(){
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        /*
         Use this method to restore finished transactions—that is, transactions for which you have already called finishTransaction(_:).
         You call this method in one of the following situations:
            - To install purchases on additional devices
            - To restore purchases for an application that the user deleted and reinstalled
         */
        SKPaymentQueue.default().restoreCompletedTransactions()
    }


}
