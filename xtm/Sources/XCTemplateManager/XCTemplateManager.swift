//
//  XCTemplateManager.swift
//
//  Created by Cameron Ingham on 8/14/18.
//

import Foundation
import Files
import Rainbow

public final class XCTemplateManager {
    
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() throws {
        
        moveTemplates()
        
        if arguments.count > 1 {

            let argument = arguments[1]
            
            switch argument {
            case "--install", "-i":
                install()
            case "--list", "-l":
                list()
            case "--remove", "-r":
                remove()
            case "--enable", "-e":
                enable()
            case "--disable", "-d":
                disable()
            case "--open", "-o":
                open()
            case "--update", "-u":
                print("Updating")
            case "--version", "-v":
                version()
            case "--help", "-h":
                help()
            default:
                help()
            }
            
        } else {
            help()
        }
    }
    
    private func install() {
        if arguments.count == 3 {
            do {
                let url = arguments[2]
                let random = randomString(length: 15)
                try FileSystem().createFolderIfNeeded(at: "~/.xtm/temporary/")
                let folderPath = try Folder(path: "~/.xtm/temporary/")
                let _ = shell(launchPath: "/usr/bin/git", arguments: ["clone", "\(url)", "\( try folderPath.createSubfolderIfNeeded(withName: random).path)"])
                let newTemplateFolder = try folderPath.subfolder(named: random)
                for template in newTemplateFolder.subfolders {
                    if template.name.hasSuffix(".xctemplate"){
                        let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                        do {
                            try template.move(to: templatesFolder)
                            print("\(template.name.replacingOccurrences(of: ".xctemplate", with: "")) has been installed successfully!".green)
                        } catch {
                            print("Template with name of \(template.name.replacingOccurrences(of: ".xctemplate", with: "")) already exists.".red.bold)
                        }
                    }
                }
                try Folder(path: "~/.xtm").delete()
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        } else {
            print("Invalid argument usage.\n".red.bold)
            print("To use, run: " + "xtm -i template_url")
        }
    }
    
    private func moveTemplates() {
        do {
            try FileSystem().createFolder(at: "~/Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
            let rootTemplatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/")
            for template in rootTemplatesFolder.subfolders {
                if template.name != "Template Manager" {
                    let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                    try template.move(to: templatesFolder)
                }
            }
        } catch {
            print("\(error.localizedDescription)".red.bold)
        }
    }
    
    private func list() {
        do {
            let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
            if templatesFolder.subfolders.count > 0 {
                for template in templatesFolder.subfolders {
                    if template.name.contains(".xctemplatedisabled") {
                        print("\(template.name.replacingOccurrences(of: ".xctemplatedisabled", with: ""))".lightRed + " (Disabled)")
                    } else {
                        print("\(template.name.replacingOccurrences(of: ".xctemplate", with: ""))".green)
                    }
                }
            } else {
                print("No Templates")
            }
        } catch {
            do {
                try FileSystem().createFolder(at: "~/Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                print("No Templates")
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        }
    }
    
    private func remove() {
        if arguments.count == 3 {
            let templateToDelete = arguments[2]
            do {
                let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                if templatesFolder.containsSubfolder(named: "\(templateToDelete).xctemplate"){
                    do {
                        try Folder(path: "~/Library/Developer/Xcode/Templates/Project Templates/Template Manager/\(templateToDelete).xctemplate").delete()
                        print("\(templateToDelete) removed".green)
                    } catch {
                        print("\(error.localizedDescription)".red.bold)
                    }
                } else if templatesFolder.containsSubfolder(named: "\(templateToDelete).xctemplatedisabled"){
                    do {
                        try Folder(path: "~/Library/Developer/Xcode/Templates/Project Templates/Template Manager/\(templateToDelete).xctemplatedisabled").delete()
                        print("\(templateToDelete) Removed".green)
                    } catch {
                        print("\(error.localizedDescription)".red.bold)
                    }
                } else {
                    print("That template does not exist.".red.bold)
                }
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        } else {
            print("Invalid argument usage.\n".red.bold)
            print("To use, run: " + "xtm -r template_name")
        }
    }
    
    private func enable() {
        if arguments.count == 3 {
            let templateToEnable = arguments[2]
            do {
                let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                if templatesFolder.containsSubfolder(named: "\(templateToEnable).xctemplate"){
                    print("\(templateToEnable) already enabled".green)
                } else if templatesFolder.containsSubfolder(named: "\(templateToEnable).xctemplatedisabled"){
                    do {
                        try Folder(path: "~/Library/Developer/Xcode/Templates/Project Templates/Template Manager/\(templateToEnable).xctemplatedisabled").rename(to: "\(templateToEnable).xctemplate", keepExtension: false)
                        print("\(templateToEnable) enabled".green)
                    } catch {
                        print("\(error.localizedDescription)".red.bold)
                    }
                } else {
                    print("That template does not exist.".red.bold)
                }
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        } else {
            print("Invalid argument usage.\n".red.bold)
            print("To use, run: " + "xtm -e template_name")
        }
    }
    
    private func disable() {
        if arguments.count == 3 {
            let templateToDisable = arguments[2]
            do {
                let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                if templatesFolder.containsSubfolder(named: "\(templateToDisable).xctemplatedisabled"){
                    print("\(templateToDisable) already disabled".green)
                } else if templatesFolder.containsSubfolder(named: "\(templateToDisable).xctemplate"){
                    do {
                        try Folder(path: "~/Library/Developer/Xcode/Templates/Project Templates/Template Manager/\(templateToDisable).xctemplate").rename(to: "\(templateToDisable).xctemplatedisabled", keepExtension: false)
                        print("\(templateToDisable) disabled".green)
                    } catch {
                        print("\(error.localizedDescription)".red.bold)
                    }
                } else {
                    print("That template does not exist.".red.bold)
                }
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        } else {
            print("Invalid argument usage.\n".red.bold)
            print("To use, run: " + "xtm -d template_name")
        }
    }
    
    private func open() {
        do {
            let templatesFolderPath = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/").path
            let _ = shell(launchPath: "/usr/bin/open", arguments: [templatesFolderPath])
            
        } catch {
            print("\(error.localizedDescription)".red.bold)
        }
    }
    
    private func version() {
        if arguments.count == 3 {
            let templateName = arguments[2]
            do {
                let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                if templatesFolder.containsSubfolder(named: "\(templateName).xctemplate"){
                    let templateFolder = try templatesFolder.subfolder(named: "\(templateName).xctemplate")
                    if templateFolder.containsFile(named: "version.txt") {
                        let versionFile = try templateFolder.file(named: "version.txt")
                        let version = try versionFile.readAsString()
                        print("Version: " + "\(version)".green)
                    } else {
                        print("This template does not contain any version info.".red.bold)
                    }
                } else if templatesFolder.containsSubfolder(named: "\(templateName).xctemplatedisabled"){
                    let templateFolder = try templatesFolder.subfolder(named: "\(templateName).xctemplatedisabled")
                    if templateFolder.containsFile(named: "version.txt") {
                        let versionFile = try templateFolder.file(named: "version.txt")
                        let version = try versionFile.readAsString()
                        print("Version: " + "\(version)".green)
                    } else {
                        print("This template does not contain any version info.".red.bold)
                    }
                } else {
                    print("That template does not exist.".red.bold)
                }
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        } else {
            let sema = DispatchSemaphore( value: 0)

            guard let url = URL(string: "https://raw.githubusercontent.com/Camji55/Xcode-Template-Manager/master/version.txt") else {
                print("Current: \(currentVersion)")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print("Current: \(currentVersion)")
                    sema.signal()
                    return
                }
                
                guard let data = data, let latestVersion = String(data: data, encoding: .utf8) else {
                    print("Current: \(currentVersion)")
                    sema.signal()
                    return
                }
                
                if !latestVersion.contains(currentVersion) {
                    print("Current: " + "\(currentVersion)".red + "\nLatest: " + "\(latestVersion)".green)
                    print("To update, run: " + "xtm -u".bold)
                } else {
                    print("Current: " + "\(currentVersion)".green + "\nLatest: " + "\(latestVersion)".green)
                }
                
                sema.signal()
            }.resume()
            sema.wait();
        }
    }
    
    private func help() {
        print("Usage:\n")
        print("  xtm -i <template>")
        print("  xtm --install <template>")
        print("    Install a new template.\n")
        print("  xtm -l")
        print("  xtm --list")
        print("    Lists all templates.\n")
        print("  xtm -r <template>")
        print("  xtm --remove <template>")
        print("    Removes template.\n")
        print("  xtm -e <template>")
        print("  xtm --enable <template>")
        print("    Enables template.\n")
        print("  xtm -d <template>")
        print("  xtm --disable <template>")
        print("    Disables template.\n")
        print("  xtm -o")
        print("  xtm --open")
        print("    Opens the Template Manager folder in Finder.\n")
        print("  xtm -u")
        print("  xtm --update")
        print("    Updates Xcode Template Manager to latest version.\n")
        print("  xtm -u <template>")
        print("  xtm --update <template>")
        print("    Updates template to latest version.\n")
        print("  xtm -v")
        print("  xtm --version")
        print("    Version info of Xcode Template Manager.\n")
        print("  xtm -v <template>")
        print("  xtm --version <template>")
        print("    Version info of template.\n")
        print("  xtm -h")
        print("  xtm --help")
        print("    How to use Xcode Template Manager.")
    }
    
    private func shell(launchPath: String, arguments: [String]) -> String? {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        
        return output
    }
    
    private func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}
