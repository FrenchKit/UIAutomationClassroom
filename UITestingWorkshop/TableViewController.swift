//
//  Copyright © 2017 Zalando SE. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var items: [TableItem] = ItemGenerator.generate()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityIdentifier = "table"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableItemCell", for: indexPath) as! TableItemCell
        cell.configure(items[indexPath.row])
        cell.accessibilityIdentifier = "cell\(indexPath.row)"
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentItem(items[indexPath.row])
    }

    fileprivate func presentMoreInfo(_ cell: TableItemCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = items[indexPath.row]
        let alert = UIAlertController(title: "Info", message: item.title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func presentItem(_ item: TableItem) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ItemViewController")
            as? ItemViewController else { return }
        controller.item = item
        show(controller, sender: nil)
    }
}

extension TableViewController: TableItemCellDelegate {

    func tableItemCellMoreInfo(_ cell: TableItemCell) {
        presentMoreInfo(cell)
    }

}
