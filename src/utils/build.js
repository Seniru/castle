module.exports = () => {
    const fs = require("fs")
    return fs.readFileSync("src/utils/utils.lua")
}