import UIKit

final class ImageCollectionViewController: UICollectionViewController {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var clearSearchButton: UIBarButtonItem!
    
    private let reuseIdentifier = "ImageCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var searches: [FlickrSearchResults] = []
    private let flickr = Flickr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
    @IBAction func clearSearchButtonAction(_ sender: UIBarButtonItem) {
        print("🟢 Clear Search button did tapped!")
        searchTextField.text = ""
    }
}

// MARK: - Private
private extension ImageCollectionViewController {
  func image(for indexPath: IndexPath) -> FlickrImage {
    return searches[indexPath.section].searchResults[indexPath.row]
  }
}

// MARK: - Search TextField Delegate
extension ImageCollectionViewController: UITextFieldDelegate {
}
