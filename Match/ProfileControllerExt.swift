//
//  File.swift
//  Link
//
//  Created by Chandan Brown on 2/7/17.
//  Copyright © 2017 Chandan B. All rights reserved.
//


import Firebase
import AVFoundation

extension ProfileController {
    
    func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference().child("users").child(uid)
        
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
        }
        
        profilePicUpdate()
        
        if let profileImageUrl = user.profileImageUrl {
            self.imageViewBackground.loadImageUsingCacheWithUrlString(profileImageUrl)
        }

        dismiss(animated: true, completion: nil)
    }
    
    func profilePicUpdate() {
        let user = FIRAuth.auth()?.currentUser
        guard (user?.uid) != nil else {
            return
        }
        //successfully authenticated user
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference().child("Profile-Image-Name").child(uid)
        let deleteRef = FIRDatabase.database().reference().child("Profile-Image-Name").child(uid).child("image_name")
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        let metadata = FIRStorageMetadata()
        if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            deleteRef.observe(.value, with: { (snapshot) in
                if snapshot.value != nil {
                    let deleteThis = snapshot.value!
                    let storageDeleteRef = FIRStorage.storage().reference().child("profile_images").child("\(deleteThis).jpg")
                    storageDeleteRef.delete { error in
                        if error != nil {
                            print("Uh-oh, an error occurred!")
                        } else {
                            print("File deleted successfully")
                        }
                    }
                }
            })
            
            let nameValues = ["image_name": imageName]
            ref.updateChildValues(nameValues, withCompletionBlock: { (err, ref) in
            })
            
            storageRef.put(uploadData, metadata: metadata, completion: { (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    
                    let values = ["profileImageUrl": profileImageUrl]
                    self.registerUserIntoDatabaseWithUID((user?.uid)!, values: values as [String : AnyObject])
                }
            })
        }
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

}
