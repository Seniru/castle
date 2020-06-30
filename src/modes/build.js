const fs = require("fs")
const chalk = require("chalk")

module.exports = () => {
    console.log(chalk`{bgGreenBright.black.bold  MAIN }{bgBlue.whiteBright.bold  MODES }\n  > Bundling modes...`)
    let res = "\n"
    let directories = fs.readdirSync("src/modes")
    directories.splice(directories.indexOf("build.js"), 1) // builds.js is not a directory
    for (let dir of directories) {
        console.log(chalk`{bgGreenBright.black.bold  MAIN }{bgBlue.whiteBright.bold  MODES }{bgYellow.black.bold  ${dir} }`)
        let mode = require(`./${dir}/package.json`)
        res += `modes.${mode.name} = {\n\tversion = "${mode.version}",\n\tdescription = "${mode.description}",\n\tauthor = "${mode.author}"\n}\n\n`
        res += `modes.${mode.name}.main = ${fs.readFileSync("src/modes/" + dir + "/" + mode.main)}\n\n`
        console.log(chalk`  {yellow > Adding mode ${mode.name} (${mode.version}) created by ${mode.author}}`)
        console.log(chalk`  > {bold Description: } ${mode.description}`)
        console.log(chalk`  > {bold Source file: } src/modes/${dir}/${mode.main}`)
    }
    return res
}