## CSS Terminal
#
# [CSS Terminal][projecthome] is a bookmarklet that allows you to inject CSS rules directly
# into a live web page. It's handy for rapid CSS development, prototyping 
# and debugging.
# 
# You can [see the CSS Terminal in action](javascript:\(function\(\){var d=document,ct=d.getElementById\('css-terminal'\);if\(ct\){ct.focus\(\);return;}var s=d.createElement\('script'\);s.src='../lib/css-terminal-min.js';d.body.appendChild\(s\)}\)\(\)) 
# on this page or <a href="#install">install the bookmarklet</a> on your 
# favorite browser and use it on any page.
#
# The [CSS Terminal source][projectsource] is hosted on GitHub. Feel free to
# browse the source, fork and customize at will. The repository can be cloned
# at:
#
#     git://github.com/barberboy/css-terminal
#
# [projecthome]: http://barberboy.github.com/css-terminal
# [projectsource]: http://github.com/barberboy/css-terminal


#### <a id="install" href="#install">Installation</a>
#
# You can install the bookmarklet in your browser by dragging the following 
# link to your browser's bookmarks bar: <a href="javascript:(function(){var d=document,ct=d.getElementById('css_terminal');if(ct){ct.focus();return;}var s=d.createElement('script');s.src='../lib/css-terminal-min.js';d.body.appendChild(s)})()" title="CSS Terminal">CSS Terminal</a>.
#
# If you don't know how to use bookmarklets in your browser,
# [Google is your friend][howtouse].
#
# You can also [install the bookmarklet on your mobile device of choice][howtomobile]
# by using the following link: <a href="#javascript:(function(){var d=document,ct=d.getElementById('css_terminal');if(ct){ct.focus();return;}var s=d.createElement('script');s.src='../lib/css-terminal-min.js';d.body.appendChild(s)})()" title="CSS Terminal">CSS Terminal</a>. 
#
# Disclaimer: the bookmarklet is not optimized for the mobile devices. Let
# me know if you have any suggestions.
#
# [howtouse]: http://www.google.com/search?q=how+to+use+bookmarklets
# [howtomobile]: http://stevesouders.com/mobileperf/iphonesteps.php

#### <a id="howtouse" href="#howtouse">How to Use</a>
#
# Once you've installed the bookmarklet on your browser, you can click 
# the link in your browser's toolbar to activate the terminal.
#
# When the terminal is active, you can enter CSS rules in the terminal and
# they will get applied to the page. Rules will get automatically added
# when you enter a semicolon or hit the Enter key. You can also hit 
# Ctrl+Enter (or Command+Enter on Mac) to apply the rule right away.
#
# Pressing Escape or Tab will collapse the terminal, although your CSS 
# rules will still be applied to the page. You can reactivate the
# terminal by clicking the bookmark again or by clicking the CSS Terminal
# icon at the top right of the page.
#
# If you reload/refresh your page, your custom CSS rules will no longer
# apply. But when you reactivate the terminal your last set of rules are
# reapplied and you can continue editing.
#
# The CSS Terminal remembers the custom CSS rules on a per site basis.
# This means that it will store your last custom rules for
# ajaxian.com seperate from alistapart.com.

#### <a id="browsers" href="#browsers">Browser Support</a>
#
# The bookmarklet currently only works in browsers which support
# [DOM Level 2 Events][domlevel2] and fixed positioning of elements. This
# includes:
#
#   * Opera
#   * Mozilla Firefox
#   * Google Chrome
#   * Apple Safari
#   * Microsoft Internet Explorer 9+
#
# It will likely also work on mobile devices though that hasn't been tested.
#
# [domlevel2]: http://www.w3.org/TR/DOM-Level-2-Events/

#### <a id="about" href="#about">About</a>
#
# The CSS Terminal bookmarklet was written by Ben Barber while working at
# [i2rd / Vipa Solutions][vipa]. The code was generously donated to the 
# community under the <a href="#license">MIT license</a>.
#
# The terminal source is written in [CoffeeScript][cs] and resulting 
# JavaScript is minified using [Google's Closure Compiler][closure]. 
# [Docco][docco] is used to generate the documentation (this page) from the 
# CoffeeScript source.
#
# [vipa]: http://www.vipasolutions.com
# [cs]: http://jashkenas.github.com/coffee-script/
# [closure]: http://code.google.com/closure/compiler/docs/gettingstarted_app.html
# [docco]: http://jashkenas.github.com/docco/

#### <a id="source" href="#source">Source Documentation</a>

# Launch the CSS Terminal and return if the css-terminal element is already
# in the document.
terminal = document.getElementById 'css-terminal'
if terminal
  terminal.focus()
  return

# Utility function which returns the value of a cookie or a default value
# if the cookie is not found.
cookieValue = (requested = 'css-terminal', defaultValue = '/** Add CSS rules here */\n') ->
  for cookie in document.cookie.split ';'
    c = cookie.split '='
    return unescape c[1] if c[0].replace(/^\s+/, "") is requested
  return defaultValue

# Utility function for creating a new element and setting initial properties
newElement = (tagname, properties) ->
  el = document.createElement tagname
  for name, value of properties
    el[name] = value
  return el

# Store some of the important key codes to make the keydown listeners
# more readable.
key = enter: 13, escape: 27, semicolon: 59

# Cache the head and body tags which we'll use when we start adding elements.
head = document.getElementsByTagName('head')[0]
body = document.getElementsByTagName('body')[0]

# Fetch the previous set of rules which we stored in a cookie.
previousStyles = cookieValue()

# Include the default styles for the CSS Terminal.
head.appendChild newElement 'link', 
  href : '../resources/css-terminal.css'
  rel : 'stylesheet'

# Create and append a textarea to the document which will be used to add
# CSS rules. The initial value for the textarea will be the last value stored
# in a cookie.
body.appendChild terminal = newElement 'textarea'
  id : 'css-terminal'
  value : previousStyles
  autocorrect : 'off'
  autocapitalize : 'off'

# Create and append the style element to the page where we will add the
# CSS rules from the CSS Terminal.
body.appendChild output = newElement 'style', 
  id : 'css-terminal-output'
  innerHTML : previousStyles

# Keydown events are observed and the styles are added to the page if the user
# hits 'enter' or types a semicolon. The CSS rules are also stored in a cookie
# so they will be persisted across page refreshes.
#
# We are also listening for the 'escape' key, and we'll close the terminal if 
# the user hits 'escape'.
terminal.addEventListener 'keydown', (ev) ->
  ev.stopPropagation();      
  pressed = ev.keyCode
  css = this.value
  oneYearFromNow = new Date(+new Date()+31536E6).toGMTString()
  if key.enter is pressed or (key.semicolon is pressed and !ev.shiftKey)
    output.innerHTML = css;
    document.cookie = "css-terminal=#{escape css}; expires=#{oneYearFromNow}; path=/"
  terminal.blur() if key.escape is pressed
, true

# Add some inline positioning to prevent browsers from focusing the bottom of
# the document when the terminal is focused.
terminal.style.position = 'fixed'

# Finally, focus the terminal which will make it visible and allow the user to 
# add rules.
terminal.focus()

#### <a id="license" href="#license">License</a>
#
# Copyright (C) 2010-2011 by Interactive Information Research and Development
#  (i2rd)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.    
