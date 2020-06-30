module.exports = () => {
    const fs = require("fs")
    const chalk = require("chalk")
    console.log(chalk`{bgGreenBright.black.bold  MAIN }{bgBlue.whiteBright.bold  UTILS }\n  > Bundling utils...`)
    return fs.readFileSync("src/utils/utils.lua")
}