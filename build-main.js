const fs = require("fs")
const chalk = require("chalk")

console.log(chalk`{bgGreenBright.black.bold  MAIN } Reading the init file...`)

let script = fs.readFileSync("init.lua", "utf-8") // reading the script content

// Handling requires
for (let required of script.match(/(?<=-- \[\[ {%require ).+(?=} \]\] --)/g)) {
    console.log(chalk`{bgGreenBright.black.bold  MAIN } Handling require (${required}) ...`)
    let res = require(`./${required}/build`)()
    script = script.replace(new RegExp(`-- .+{%require ${required}} ]] --`, "g"), res)
}

console.log(chalk`{bgGreenBright.black.bold  MAIN } Writing to the file...`)
fs.writeFileSync("builds/latest.lua", script)
console.log(chalk`{bgGreenBright.black.bold  MAIN } Build completed...`)
