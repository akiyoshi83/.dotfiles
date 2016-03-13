@echo off

setx GOPATH "C:\\Users\\suzyosh"
setx HOME "C:\\Users\\suzyosh"

setx BIND_HOME "C:\\Program Files\\ISC BIND 9"
setx CLINK_HOME "C:\\tools\\clink_0.4.7"
setx GOROOT "C:\\Go\\"
setx JQ_HOME "C:\\tools\\jq"
setx PY_HOME "C:\\Python27;C:\\Python27\\Scripts"
setx RUBY_HOME "C:\\Ruby22-x64"
setx URU_HOME "C:\\tools\\uru-0.8.1-windows-x86"
setx VIM_HOME "C:\\tools\\vim74-kaoriya-win64"

setx PATH_TOOLS "%BIND_HOME%;%CLINK_HOME%;%GOROOT%\bin;%JQ_HOME%;%PY_HOME%;%RUBY_HOME%\bin;%URU_HOME%;%VIM_HOME%"

exit /B
