#
#  JackerController.rb
#  JackerApp
#
#  Created by Scott Barron on 9/23/08.
#  Copyright (c) 2008. All rights reserved.
#

require 'osx/cocoa'

require 'rubygems'
require 'jacker'

class JackerController < OSX::NSWindowController
  include OSX
  
  ib_outlet :theMenu
  ib_outlet :jackItem
  ib_outlet :statusItem
  
  ib_action :jackIt
  ib_action :startJacking
    
  def awakeFromNib
    statusbar = NSStatusBar.systemStatusBar
    item = statusbar.statusItemWithLength(NSVariableStatusItemLength)
    item.setTitle "J"
    item.setHighlightMode true
    
    item.setMenu(@theMenu)
    item.setEnabled(true)
    setMenuStatus
  end
  
  def jackIt(sender)
    if Jacker.running?
      self.stopJacking
    else
      showWindow(self)
    end
  end
  
  def startJacking(sender)
    close
    Jacker.start sender.stringValue
    setMenuStatus
    sender.setStringValue ""
  end
  
  def stopJacking
    Jacker.stop
    setMenuStatus
  end
  
  def setMenuStatus
    @jackItem.setTitle Jacker.running? ? "Stop Jacking" : "Start Jacking"
    @statusItem.setTitle Jacker.status
  end
  
  def menuWillOpen(menu)
    setMenuStatus
  end
end
