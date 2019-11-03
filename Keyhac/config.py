# Keyhac で Windows のキーバインドを Mac の英語キーボードに近づける。
# 前提条件: KeySwap などで CapsLock と RCtrl が変更済みであること。
# 主な変更点:
# - LAlt => 無変換 (LUser0)
# - RAlt => 変換 (RUser0)
# - LWindows => LAlt
# - RWindows => RAlt
# - LCtrl => LWindows
import sys
import os
import datetime

import pyauto
from keyhac import *

def configure(keymap):
    # --------------------------------------------------------------------
    # Text editer setting for editting config.py file
    def editor(path):
        shellExecute( None, "vim.exe", '"%s"'% path, "" )
    keymap.editor = editor

    # --------------------------------------------------------------------
    # Customizing the display

    # Font
    keymap.setFont( "MS Gothic", 12 )

    # Theme
    keymap.setTheme("black")

    # --------------------------------------------------------------------
    # Replace keys
    keymap.replaceKey("LCtrl", "LWin")
    keymap.replaceKey("LWin", "LAlt")
    keymap.replaceKey("RWin", "RAlt")

    # 28 = VK_CONVERT
    # 29 = VK_NONCONVERT
    keymap.replaceKey("LAlt", 29)
    keymap.replaceKey("RAlt", 28)
    keymap.defineModifier(29, "LUser0")
    keymap.defineModifier(28, "RUser0")

    # --------------------------------------------------------------------
    # Global keymap
    keymap_global = keymap.defineWindowKeymap()

    keymap_global["U0-Ctrl-R"] = keymap.command_ReloadConfig
    keymap_global["U0-Ctrl-E"] = keymap.command_EditConfig

    keymap_global["U0-S-CloseBracket"]  = "C-Tab"
    keymap_global["U0-S-OpenBracket"]  = "C-S-Tab"
    keymap_global["U0-Tab"] = "A-Tab"
    keymap_global["U0-S-Tab"] = "A-S-Tab"

    # --------------------------------------------------------------------
    # IME On/Off
    def ime_on():
        keymap.wnd.setImeStatus( 1 )

    def ime_off():
        keymap.wnd.setImeStatus( 0 )

    keymap_global["O-29"] = ime_off
    keymap_global["O-28"] = ime_on

    # --------------------------------------------------------------------
    # Keymap for editable area
    def set_editor_keymap(_keymap):
        _keymap[ "U0-A" ] = "Ctrl-A"            # Select all
        _keymap[ "U0-C" ] = "Ctrl-C"            # Copy
        _keymap[ "U0-X" ] = "Ctrl-X"            # Cut
        _keymap[ "U0-V" ] = "Ctrl-V"            # Paste
        _keymap[ "U0-S" ] = "Ctrl-S"            # Save
        _keymap[ "U0-Z" ] = "Ctrl-Z"            # Undo
        _keymap[ "U0-S-Z" ] = "Ctrl-Y"          # Redo
        _keymap[ "U0-Y" ] = "Ctrl-Y"            # Redo
        _keymap[ "U0-F" ] = "Ctrl-F"            # Find
        _keymap[ "C-D" ] = "Delete"             # Delete
        _keymap[ "C-H" ] = "Back"               # Backspace
        _keymap[ "C-K" ] = "S-End","Delete"     # Removing following text
        _keymap[ "C-P" ] = "Up"                 # Move cursor up
        _keymap[ "C-N" ] = "Down"               # Move cursor down
        _keymap[ "C-F" ] = "Right"              # Move cursor right
        _keymap[ "C-B" ] = "Left"               # Move cursor left
        _keymap[ "C-A" ] = "Home"               # Move to beginning of line
        _keymap[ "C-E" ] = "End"                # Move to end of line
        _keymap[ "A-F" ] = "C-Right"            # Word right
        _keymap[ "A-B" ] = "C-Left"             # Word left
        _keymap[ "U0-Left"] = "Home"            # Select to beginning of line
        _keymap[ "U0-Right"] = "End"            # Select to end of line
        _keymap[ "U0-S-Left"] = "S-Home"        # Select to beginning of line
        _keymap[ "U0-S-Right"] = "S-End"        # Select to end of line
        _keymap[ "U0-B" ] = withC("C-B")        # Bold
        _keymap[ "U0-I" ] = withC("C-I")        # Italic
        _keymap[ "U0-I" ] = withC("C-U")        # Underline
        _keymap[ "U0-I" ] = withC("C-T")        # Strikethrough

    def set_terminal_keymap(_keymap):
        _keymap[ "C-D" ] = "Delete"              # Delete
        _keymap[ "C-H" ] = "Back"                # Backspace
        _keymap[ "C-K" ] = "S-End","Delete"      # Removing following text
        _keymap[ "C-P" ] = "Up"                  # Move cursor up
        _keymap[ "C-N" ] = "Down"                # Move cursor down
        _keymap[ "C-F" ] = "Right"               # Move cursor right
        _keymap[ "C-B" ] = "Left"                # Move cursor left
        _keymap[ "C-A" ] = "Home"                # Move to beginning of line
        _keymap[ "C-E" ] = "End"                 # Move to end of line
        _keymap[ "C-W" ] = "C-Back"              # Backspace a word

    if 1:
        set_editor_keymap(keymap.defineWindowKeymap( class_name="Edit" ))
        set_editor_keymap(keymap.defineWindowKeymap( exe_name="Evernote.exe" ))
        #set_editor_keymap(keymap.defineWindowKeymap( exe_name="Code.exe" ))

        #set_terminal_keymap(keymap.defineWindowKeymap( class_name="ConsoleWindowClass" ))
        #set_terminal_keymap(keymap.defineWindowKeymap( class_name="VirtualConsoleClass" ))
        #set_terminal_keymap(keymap.defineWindowKeymap( class_name="mintty" ))
