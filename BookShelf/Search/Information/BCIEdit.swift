//
//  BCIEdit.swift
//  BookShelf
//
//  Created by steve on 2021/05/25.
//

import UIKit

class BCIEdit: BViewController {

    var onDone: blk0_t!

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tvEdit: UITextView!

    override
    func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

        lbTitle.text = "Edit - " + title!
        tvEdit.text  = text

        tvEdit.becomeFirstResponder()
    }
    
    override
    func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        text = tvEdit.text
        onDone()
    }

    @IBAction
    func btDone(_ sender: Any)
    {
        dismiss(animated: true)
    }

}
