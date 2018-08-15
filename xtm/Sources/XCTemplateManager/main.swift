let currentVersion = "0.0.1"
let tool = XCTemplateManager()

do {
    try tool.run()
} catch {
    print("Whoops! An error occurred: \(error)")
}
