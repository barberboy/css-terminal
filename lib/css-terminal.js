(function() {
  var body, cookieValue, head, key, newElement, output, previousStyles, terminal;
  terminal = document.getElementById('css-terminal');
  if (terminal) {
    terminal.focus();
    return;
  }
  cookieValue = function(requested, defaultValue) {
    var c, cookie, _i, _len, _ref;
    if (requested == null) {
      requested = 'css-terminal';
    }
    if (defaultValue == null) {
      defaultValue = '/** Add CSS rules here */\n';
    }
    _ref = document.cookie.split(';');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      cookie = _ref[_i];
      c = cookie.split('=');
      if (c[0].replace(/^\s+/, "") === requested) {
        return unescape(c[1]);
      }
    }
    return defaultValue;
  };
  newElement = function(tagname, properties) {
    var el, name, value;
    el = document.createElement(tagname);
    for (name in properties) {
      value = properties[name];
      el[name] = value;
    }
    return el;
  };
  key = {
    enter: 13,
    escape: 27,
    semicolon: 59
  };
  head = document.getElementsByTagName('head')[0];
  body = document.getElementsByTagName('body')[0];
  previousStyles = cookieValue();
  head.appendChild(newElement('link', {
    href: 'https://barberboy.github.com/css-terminal/resources/css-terminal.css',
    rel: 'stylesheet'
  }));
  body.appendChild(terminal = newElement('textarea', {
    id: 'css-terminal',
    value: previousStyles,
    autocorrect: 'off',
    autocapitalize: 'off'
  }));
  body.appendChild(output = newElement('style', {
    id: 'css-terminal-output',
    innerHTML: previousStyles
  }));
  terminal.addEventListener('keydown', function(ev) {
    var css, oneYearFromNow, pressed;
    ev.stopPropagation();
    pressed = ev.keyCode;
    css = this.value;
    oneYearFromNow = new Date(+new Date() + 31536E6).toGMTString();
    if (key.enter === pressed || (key.semicolon === pressed && !ev.shiftKey)) {
      output.innerHTML = css;
      document.cookie = "css-terminal=" + (escape(css)) + "; expires=" + oneYearFromNow + "; path=/";
    }
    if (key.escape === pressed) {
      return terminal.blur();
    }
  }, true);
  terminal.style.position = 'fixed';
  terminal.style.top = 0;
  terminal.focus();
}).call(this);
