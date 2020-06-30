const fs = require("fs")

module.exports = () => {
    let chunk = `\n`
    const chalk = require("chalk")
    console.log(chalk`{bgGreenBright.black.bold  MAIN }{bgBlue.whiteBright.bold  UTILS }\n  > Bundling translations...`)
    for (let file of fs.readdirSync("src/translations")) {
        if (/\w{2,2}.lua/.test(file)) {
            console.log(`  > Bundled translations file ${file}`)
            chunk += fs.readFileSync(`src/translations/${file}`) + "\n"
        }
    }
    return chunk
}