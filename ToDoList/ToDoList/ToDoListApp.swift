//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Kyle Colby on 10/12/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var windowController: NSWindowController!
    var viewController: ToDoList!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the window
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                          styleMask: [.titled, .closable, .resizable],
                          backing: .buffered,
                          defer: false)
        window.title = "To-Do List"
        
        // Create and set the view controller
        viewController = ToDoList()
        window.contentView = viewController.view
        
        // Create a window controller to manage the window
        windowController = NSWindowController(window: window)
        windowController.showWindow(self) // Ensure the window is shown

        // Make the window visible and key
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Insert code here to tear down your application
    }
}

class ToDoList: NSViewController {
    // Data storage
    var tasks: [String] = []
    
    // UI components
    var tableView: NSTableView!
    var textField: NSTextField!
    var addButton: NSButton!
    var removeButton: NSButton!
    
    override func loadView() {
        // Create the view
        view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
        
        // Create the text field
        textField = NSTextField(frame: NSRect(x: 0, y: 210, width: 200, height: 20))
        view.addSubview(textField)
        
        // Create the add button
        addButton = NSButton(title: "Add", target: self, action: #selector(addTask))
        addButton.frame = NSRect(x: 210, y: 210, width: 60, height: 20)
        view.addSubview(addButton)
        
        // Create the remove button
        removeButton = NSButton(title: "Remove", target: self, action: #selector(removeTask))
        removeButton.frame = NSRect(x: 270, y: 210, width: 60, height: 20)
        view.addSubview(removeButton)
        
        // Set up the table view
        tableView = NSTableView(frame: NSRect(x: 0, y: 0, width: 400, height: 200))
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "TaskColumn"))
        column.title = "Tasks"
        tableView.addTableColumn(column)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    // Data source methods
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return tasks[row]
    }
    
    // Delegate methods
    func tableViewSelectionDidChange(_ notification: Notification) {
        // Update the remove button's state
        removeButton.isEnabled = tableView.selectedRow != -1
    }
    
    // Action methods
    @objc func addTask() {
        // Get the text from the text field
        let text = textField.stringValue
        
        // Add the task to the data storage
        tasks.append(text)
        
        // Update the table view
        tableView.reloadData()
        
        // Clear the text field
        textField.stringValue = ""
    }
    
    @objc func removeTask() {
        // Get the selected row
        let row = tableView.selectedRow
        
        // Ensure a valid row is selected
        guard row != -1 else { return }
        
        // Remove the task from the data storage
        tasks.remove(at: row)
        
        // Update the table view
        tableView.reloadData()
    }
}

// Extend ToDoList to conform to NSTableViewDataSource and NSTableViewDelegate
extension ToDoList: NSTableViewDataSource, NSTableViewDelegate {}
