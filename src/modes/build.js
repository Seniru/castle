const fs = require("fs")

module.exports = () => {
    let res = "\n"
    let directories = fs.readdirSync("src/modes")
    directories.splice(directories.indexOf("build.js"), 1) // builds.js is not a directory
    for (let dir of directories) {
        let mode = require(`./${dir}/package.json`)
        res += `modes.${mode.name} = {\n\tversion = "${mode.version}",\n\tdescription = "${mode.description}",\n\tauthor = "${mode.author}"\n}\n\n`
        res += `modes.${mode.name}.main = ${fs.readFileSync("src/modes/" + dir + "/" + mode.main)}\n\n`
    }
    return res
}