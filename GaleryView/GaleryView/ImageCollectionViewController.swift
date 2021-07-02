import UIKit

final class ImageCollectionViewController: UICollectionViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var clearSearchButton: UIBarButtonItem!
    
    private let reuseIdentifier = "ImageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
    @IBAction func clearSearchButtonAction(_ sender: UIBarButtonItem) {
        print("🟢 Clear Search button did tapped!")
        searchTextField.text = ""
    }
}

extension ImageCollectionViewController: UITextFieldDelegate {
}
