//
//  ContactsPicker.swift
//  YYUIKitDemo
//
//  Created by will on 2025/3/7.
//

import SwiftUI
import Contacts

struct ContentView: View {
    @State private var selectedContact: CNContact?
    @State private var isShowingContactPicker = false

    var body: some View {
        VStack {
            if let contact = selectedContact {
                Text("Selected Contact:")
                    .font(.headline)
                Text("Name: \(contact.givenName) \(contact.familyName)")
                if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                    Text("Phone: \(phoneNumber)")
                }
            } else {
                Text("No contact selected.")
            }

            Button("Select Contact") {
                isShowingContactPicker = true
            }
            .sheet(isPresented: $isShowingContactPicker) {
                ContactPicker(selectedContact: $selectedContact)
            }
        }
        .padding()
    }
}

import SwiftUI
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {
    @Binding var selectedContact: CNContact?

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.selectedContact = contact
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            parent.selectedContact = nil
        }
    }
}
