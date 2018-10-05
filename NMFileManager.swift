//
//  NMFileManager.swift
//  NMFileManager
//
//  Created by Natalia Macambira on 23/09/17.
//  Copyright © 2017 Natalia Macambira. All rights reserved.
//

import UIKit

final class NMFileManager {
    
    static let fileManager = FileManager.default
    
    // MARK: - Create folder
    
    /// Create a folder on disk in document directory
    ///
    /// - Parameter folderPath: Folder's name string
    static func createFolder(_ folderPath: String) {
        let documentsDirectory = getDocumentsDirectory()
        let projectFolder = documentsDirectory.appendingPathComponent(folderPath)
        
        if !fileManager.fileExists(atPath: projectFolder.path) {
            do {
                try fileManager.createDirectory(atPath: projectFolder.path, withIntermediateDirectories: false, attributes: nil)
                print("Folder \(folderPath) created at: ", projectFolder)
            } catch (let error) {
                print("Error - Folder \(folderPath) was not created: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Delete folder
    
    /// Delete a folder from document directory
    ///
    /// - Parameter folderPath: Folder's name string
    static func deleteFolder(_ folderPath: String) {
        let documentsDirectory = getDocumentsDirectory()
        let projectFolder = documentsDirectory.appendingPathComponent(folderPath)
        
        if !fileManager.fileExists(atPath: projectFolder.path) {
            do {
                try fileManager.removeItem(atPath: projectFolder.path)
                print("Folder \(folderPath) deleted")
            } catch (let error) {
                print("Error - Folder \(folderPath) was not deleted: ", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Save file from Bundle on disk
    
    /// Save file from app's folder on disk
    ///
    /// - Parameter fileName: File's name string
    static func saveFile(_ fileName: String) {
        let nameArray = fileName.components(separatedBy: ".")
        if let bundleFileUrl = Bundle.main.url(forResource: nameArray[0], withExtension: nameArray[1]) {
            let documentDirectoryFileUrl = getFileLocation(fileName)
            if !fileManager.fileExists(atPath: documentDirectoryFileUrl.path) {
                do {
                    try fileManager.copyItem(at: bundleFileUrl, to: documentDirectoryFileUrl)
                    print("Copy file succcess: ", fileName)
                    print("File location: \(documentDirectoryFileUrl.path)")
                } catch (let error) {
                    print("Could not copy file to disk: \(error.localizedDescription)")
                }
            } else {
                print("File already exists in File Manager Directory!")
            }
        } else {
            print("File don't exist in Bundle")
        }
    }
    
    // MARK: - Save file on disk
    
    /// Save file on disk
    ///
    /// - parameters:
    ///     - fileName: File name string
    ///     - downloadLocation: The location of the file after the download request
    static func saveFile(_ fileName: String, from downloadLocation: URL) {
        let documentDirectoryFileUrl = getFileLocation(fileName)
        if !fileManager.fileExists(atPath: documentDirectoryFileUrl.path) {
            do {
                try fileManager.copyItem(at: downloadLocation, to: documentDirectoryFileUrl)
                print("Copy file succcess: ", fileName)
                print("File location: \(documentDirectoryFileUrl.path)")
            } catch (let error) {
                print("Could not copy file to disk: \(error.localizedDescription)")
            }
        } else {
            print("File already exists in File Manager Directory!")
        }
    }
    
    // MARK: - Save image on disk
    
    /// Save image on disk
    ///
    /// - parameters:
    ///     - image: The image you want to save
    ///     - imageName: Image's name string
    static func saveImage(_ image: UIImage, with imageName: String) {
        let nameArray = imageName.components(separatedBy: ".")
        let extensionType = nameArray[1].lowercased()
        let documentDirectoryImageUrl = getFileLocation(imageName)
        
        if !fileManager.fileExists(atPath: documentDirectoryImageUrl.path) {
            var imageData: Data? = nil
            
            switch extensionType {
            case "png":
                imageData = UIImagePNGRepresentation(image)
            case "jpg" :
                imageData = UIImageJPEGRepresentation(image, 0.8)
            default:
                return
            }
            guard let data = imageData else { return }
            
            do {
                try data.write(to: documentDirectoryImageUrl)
                print("Save image succcess: ", imageName)
                print("File location: \(documentDirectoryImageUrl.path)")
            } catch (let error) {
                print("Could not save image to disk: \(error.localizedDescription)")
            }
        } else {
            print("File already exists in File Manager Directory!")
        }
    }
    
    // MARK: - Get file from directory
    
    /// Get a specific file from File Manager Directory
    ///
    /// - Parameter fileName: The string of the name of the file
    /// - Returns: URL The url with the location of the file, if it exists.
    static func getFile(_ fileName: String) -> URL? {
        let documentDirectoryFileUrl = getFileLocation(fileName)
        if fileManager.fileExists(atPath: documentDirectoryFileUrl.path) {
            return documentDirectoryFileUrl
        }
        return nil
    }
    
    // MARK: - Get image from directory
    
    /// Get a specific image from File Manager Directory
    ///
    /// - Parameter imageName: The string of the name of the image
    /// - Returns: UIImage The image found in the directory.
    static func getImage(_ imageName: String) -> UIImage? {
        let documentDirectoryImageUrl = getFileLocation(imageName)
        if fileManager.fileExists(atPath: documentDirectoryImageUrl.path) {
            if let image = UIImage(contentsOfFile: documentDirectoryImageUrl.path) {
                return image
            }
        }
        return nil
    }
    
    // MARK: - Get file location in documents Directory
    
    /// Get file location in File Manager Directory
    ///
    /// - Parameter fileName: The string of the name of the file
    /// - Returns: URL The url of the file.
    private static func getFileLocation(_ fileName: String) -> URL {
        let documentDirectory = getDocumentsDirectory()
        let fileUrl = documentDirectory.appendingPathComponent(fileName)
        //print("Get file from: ", fileUrl)
        return fileUrl
    }
    
    // MARK: - Get user's documents directory
    
    /// Get user's documents directory location
    ///
    /// - Returns: URL The url of the document directory.
    private static func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
