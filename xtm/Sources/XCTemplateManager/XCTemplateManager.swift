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
                print("Installing")
            case "--list", "-l":
                list()
            case "--remove", "-r":
                remove()
            case "--enable", "-e":
                enable()
            case "--disable", "-d":
                disable()
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
                for template in templatesFolder.subfolders {
                    if template.name.replacingOccurrences(of: ".xctemplate", with: "") == templateToDelete {
                        do {
                            try template.delete()
                            print("\(template.name.replacingOccurrences(of: ".xctemplate", with: "")) Removed".green)
                        } catch {
                            print("\(error.localizedDescription)".red.bold)
                        }
                    } else {
                        print("That template does not exist.".red.bold)
                    }
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
                for template in templatesFolder.subfolders {
                    if template.name.replacingOccurrences(of: ".xctemplatedisabled", with: "") == templateToEnable {
                        do {
                            try template.rename(to: template.name.replacingOccurrences(of: ".xctemplatedisabled", with: ".xctemplate"), keepExtension: false)
                            print("\(templateToEnable) Enabled".green)
                        } catch {
                            print("\(error.localizedDescription)".red.bold)
                        }
                    } else {
                        print("That template does not exist.".red.bold)
                    }
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
            let templateToDisable = arguments[2].replacingOccurrences(of: ".xctemplate", with: ".xctemplatedisabled")
            do {
                let templatesFolder = try Folder.home.subfolder(atPath: "Library/Developer/Xcode/Templates/Project Templates/Template Manager/")
                for template in templatesFolder.subfolders {
                    if template.name.replacingOccurrences(of: ".xctemplate", with: "") == templateToDisable {
                        do {
                            try template.rename(to: template.name.replacingOccurrences(of: ".xctemplate", with: ".xctemplatedisabled"), keepExtension: false)
                            print("\(templateToDisable.replacingOccurrences(of: ".xctemplate", with: ".xctemplatedisabled")) Disabled".green)
                        } catch {
                            print(error.localizedDescription)
                        }
                    } else {
                        print("That template does not exist.".red.bold)
                    }
                }
            } catch {
                print("\(error.localizedDescription)".red.bold)
            }
        } else {
            print("Invalid argument usage.\n".red.bold)
            print("To use, run: " + "xtm -d template_name")
        }
    }
    
    private func version() {
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
    
}
