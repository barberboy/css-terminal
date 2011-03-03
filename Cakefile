fs     = require 'fs'
{exec} = require 'child_process'

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

task 'minify', 'Minify the resulting application file after build.', ->
  console.log 'Minifying .js files...'
  exec 'java -jar /usr/local/lib/closure-compiler/compiler.jar --js lib/css-terminal.js --js_output_file lib/css-terminal-min.js', pass_w_message '...minification complete.'

task 'document', 'Generate source documentation.', ->
  console.log 'Generating documentation...'
  exec 'rm -r docs/* && docco src/*.coffee', pass_w_message '...documentation complete.'

task 'build:full', 'Build and minify the .js and generate documentation', ->
  exec 'cake build', (err, stdout, stderr) ->
    pass_through err, stdout, stderr
    exec 'cake minify', (err, stdout, stderr) ->
      pass_through err, stdout, stderr
      exec 'cake document', pass_w_message 'Full build complete.'

task 'build:watch', 'Perform an initial build and rebuild whenever the source files change.', ->
  exec 'cake build:full', (err, stdout, stderr) ->
    throw err if err
    out = stdout + stderr
    console.log out if out?
    console.log 'Watching for changes...'
    fs.watchFile 'src/css-terminal.coffee', {persistent: true, interval: 500}, (curr, prev) ->
      return if curr.size is prev.size and curr.mtime.getTime() is prev.mtime.getTime()
      exec 'cake build:full', pass_through

