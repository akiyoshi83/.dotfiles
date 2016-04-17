:@echo off

call :set_both GOPATH "C:\Users\suzyosh"
call :set_both HOME "C:\Users\suzyosh"
call :set_both TOOLS_DIR "C:\Users\suzyosh\tools"

call :set_both BIND_HOME "C:\Program Files\ISC BIND 9"
call :set_both CLINK_HOME "C:\Users\suzyosh\tools\clink_0.4.7"
call :set_both GOROOT "C:\Go"
call :set_both JQ_HOME "C:\Users\suzyosh\tools\jq"
call :set_both MAVEN_HOME "C:\Users\suzyosh\tools\apache-maven-3.3.9"
call :set_both PY_HOME "C:\Python27;C:\Python27\Scripts"
call :set_both RUBY_HOME "C:\Ruby22-x64"
call :set_both URU_HOME "C:\Users\suzyosh\tools\uru-0.8.1-windows-x86"
call :set_both VIM_HOME "C:\Users\suzyosh\tools\vim74-kaoriya-win64"

setx PATH_TOOLS %HOME%\bin;%BIND_HOME%\bin;%CLINK_HOME%;%GOROOT%\bin;%JQ_HOME%;%MAVEN_HOME%;%PY_HOME%;%RUBY_HOME%\bin;%URU_HOME%;%VIM_HOME%

exit /B


REM Set local variable and User variable
:set_both
set %1=%2
setx %1 %2
exit /B
