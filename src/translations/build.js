const fs = require("fs")

module.exports = () => {
    let chunk = `\n`
    for (let file of fs.readdirSync("src/translations")) {
        if (/\w{2,2}.lua/.test(file)) {
            chunk += fs.readFileSync(`src/translations/${file}`) + "\n"
        }
    }
    return chunk
}