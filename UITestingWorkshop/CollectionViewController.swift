//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {

    var items: [CollectionItem] = ItemGenerator.generate()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.accessibilityIdentifier = "collection"
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionItemCell",
                                                      for: indexPath) as! CollectionItemCell
        cell.configure(items[indexPath.item])
        cell.accessibilityIdentifier = "cell\(indexPath.item)"
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        presentItem(items[indexPath.item])
    }

    func presentItem(_ item: CollectionItem) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ItemViewController")
            as? ItemViewController else { return }
        controller.item = TableItem(title: item.name + " - " + item.price,
                                    imageName: item.imageName)
        show(controller, sender: nil)
    }

}
