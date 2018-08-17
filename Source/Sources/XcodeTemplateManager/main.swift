let currentVersion = "0.0.1"
let tool = XcodeTemplateManager()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
