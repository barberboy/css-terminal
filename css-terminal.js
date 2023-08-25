javascript: (function () {
    var terminal = document.getElementById("css-terminal");
    if (!terminal) {
        var keymap = { enter: 13, escape: 27, semicolon: 186, forwardSlash: 191, period: 190 };
        var body = document.getElementsByTagName("body")[0];
        var previousStyles = unescape(localStorage.getItem("css-terminal") || "");
        var terminal = newElement("textarea", {
            id: "css-terminal",
            value: previousStyles,
            autocorrect: "off",
            autocapitalize: "off"
        });
        var terminalStyles = newElement("style", {
            id: "css-terminal-css",
            innerHTML: `
                #css-terminal {
                    background: transparent url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAndJREFUOMuNkr1LXEEUxX8zb3b3ze7KopDCJFVIqRBilUKCNgFZNFVAAmthJWJvVsQiTf4HQdBaEKwsFgL5kKR4YJr0msDDoMmukfF9zUya7INAIDlw4XIunHvu4Yq9vb2Ndrv9Qmtd4x9wzuG9xzmHMSY5Ojp6yfn5+Tf/n3DOeeect9Z6a60/PT09F8aY5ODgoLa7u8vMzAz/g16vx8bGBhMTE4kckk/abcbv3sUYgzGGZrPJ+vo6xhharRadTqec9Xq94SleAl4IwVW/z6PHj3nW6ZAVBdPT02xtbRHHMSsrK2W/vLxMt9slTVOMMVYCSCl5//YtH4+PuTU+TpplNBoNoigijmM2NzfpdrvEcczq6ipLS0ukaUpRFF4JIRBCMDs3h/We50+f8uP7d968fk0URUxNTbG9vc3Ozg5xHBNFEbOzs6ytrQEgkiQxh4eHenFxEaUUrVaLe/fvM/HgAQL48O4dd27f5uTkBABjDFdXV+zv7zM5OflTCSGQUmKtxVpLv9/n8vKSL2dnCCEYDAZ8OTujKAqyLCPLMgC893jvUcMQAbTWhGHIz8GAz58+IaVEACMjI+R5TpZlJEmCMQbnHABKSokQAq01jUaDMAwJw5BKpUIQBABYa8nznDRNkVL+6WAYotYarTX1ep0wDKlWqyilSoEsy1BKIYTAe18+lRqqhWFYCtTrdWq1GkEQIISgKIpyu/cea23pQjnnaDabzM/Ply5qtdpfT0iShJubG5IkQSmFcw5xfX39VQhxx1pLURR/1L+40dHR02BhYSEYGxt7+NtSDuRALqUsKwiCXCmVK6XySqWSV6vVXGs9uLi4ePULSRiabTd6gRQAAAAASUVORK5CYII=') no-repeat top right;
                    font-family: monospace;
                    position: fixed;
                    top: 0;
                    right: 0;
                    color: transparent;
                    z-index: 100000;
                    border: 0;
                    width: 32px;
                    height: 32px;               
                    max-height: 32px;                
                    overflow: hidden;              
                    cursor: pointer;          
                    resize: none;          
                }
                #css-terminal:focus {
                    background: rgba(0,0,0,.75);        
                    border: 2px solid rgba(0,0,0,.1); 
                    color: white;
                    cursor: text;
                    height: 25em;
                    max-height: none;
                    width: 40em;
                    outline: none;
                    overflow: auto;
                    padding: .25em;
                    resize: both;
                }`
        });
        var terminalOutput = newElement("style", {
            id: "css-terminal-output",
            innerHTML: previousStyles
        });

        body.appendChild(terminalStyles);
        body.appendChild(terminal);
        body.appendChild(terminalOutput);

        terminal.addEventListener("keydown", function (evt) {
            evt.stopPropagation();
            var keyCode = evt.keyCode;
            if (keyCode === keymap.enter || keyCode === keymap.semicolon && !evt.shiftKey) {
                terminalOutput.innerHTML = this.value;
                localStorage.setItem("css-terminal", escape(this.value));
            }
            if (keymap.escape === keyCode || evt.ctrlKey && keyCode === keymap.forwardSlash) {
                return terminal.blur();
            }
        }, true);

        window.addEventListener("keydown", function ({ keyCode, ctrlKey }) {
            /* ctrl + / activation shortcut */
            if (ctrlKey && keyCode === keymap.forwardSlash) {
                terminal.focus();
            }
            /* ctrl + . to make an element contenteditable */
            if (ctrlKey && keyCode === keymap.period) {
                body.addEventListener("click", makeContenteditable, true);
            }
        });

        function makeContenteditable(evt) {
            evt.preventDefault();
            evt.stopPropagation();

            evt.target.setAttribute("contenteditable", true);
            evt.target.focus();

            /* Clean up event listeners */
            body.removeEventListener("click", makeContenteditable, true);
            evt.target.addEventListener("blur", function disableContentEditable() {
                evt.target.removeAttribute("contenteditable");
                evt.target.removeEventListener("blur", disableContentEditable);
            });
        }

        function newElement(tagname, props) {
            var el = document.createElement(tagname);
            for (var i in props) {
                el[i] = props[i];
            }
            return el;
        }
    }

    terminal.focus();
})();