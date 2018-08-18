let currentVersion = "1.0.0"
let tool = XcodeTemplateManager()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
