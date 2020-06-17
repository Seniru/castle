const fs = require("fs")

let script = fs.readFileSync("init.lua", "utf-8") // reading the script content

// Handling requires
for (let required of script.match(/(?<=-- \[\[ {%require ).+(?=} \]\] --)/g)) {
    let res = require(`./${required}/build`)()
    script = script.replace(new RegExp(`-- .+{%require ${required}} ]] --`, "g"), res)
}

fs.writeFileSync("builds/latest.lua", script)
