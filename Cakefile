fs     = require 'fs'
{exec} = require 'child_process'

source = 'css-terminal'

pass_through = (err, stdout, stderr) ->
  throw err if err
  out = stdout + stderr
  console.log out if out?
pass_w_message = (msg) ->
  return (err, stdout, stderr) ->
    pass_through err, stdout, stderr
    console.log msg if msg

task 'build', 'Compile the project\'s .coffee files to .js', ->
  console.log 'Compiling .coffee sources into .js...'
  exec 'coffee --compile --lint --output lib/ src/', pass_w_message '...compilation complete.'

task 'min', 'Minify the resulting application file after build.', ->
  console.log 'Minifying .js files...'
  exec "java -jar /usr/local/lib/closure-compiler/compiler.jar --js lib/#{source}.js --js_output_file lib/#{source}-min.js", pass_w_message '...minification complete.'

task 'doc', 'Generate source documentation.', ->
  console.log 'Generating documentation...'
  exec([
    "rm -rf docs"
    "docco src/#{source}.coffee"
    "sed 's/docco.css/docs\\/docco.css/' < docs/#{source}.html > index.html"
    ].join(' && '), pass_w_message '...documentation complete.'
  )

task 'build:full', 'Build and minify the .js and generate documentation', ->
  exec 'cake build && cake min && cake doc', pass_w_message 'Full build complete.'

task 'watch', 'Perform an initial build and rebuild whenever the source files change.', ->
  exec 'cake build:full', (err, stdout, stderr) ->
    throw err if err
    out = stdout + stderr
    console.log out if out?
    console.log 'Watching for changes...'
    fs.watchFile "src/#{source}.coffee", {persistent: true, interval: 500}, (curr, prev) ->
      return if curr.size is prev.size and curr.mtime.getTime() is prev.mtime.getTime()
      exec 'cake build:full', pass_through

