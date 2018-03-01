# OSX for Hackers (Mavericks/Yosemite)
#
# Source: https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716 

# TODO: Move to ansible tasks (for bonus internet points).

# Ask for the administrator password upfront
# sudo -v #assumes ansible -ask-sudo-pass already

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

echo "This script will make your Mac awesome. Read it carefully first!"

###############################################################################
# General UI/UX
###############################################################################

fancy_echo "Hide the Time Machine, Volume, User, and Bluetooth icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults read "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults read com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu"


# fancy_echo "Hiding spotlight icon" 
# sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# to undo
# sudo chmod 755 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

fancy_echo "Disabling OS X Gate Keeper"
echo "(You'll be able to install any app you want from here on, not just Mac App Store apps)"
# sudo spctl --master-disable
defaults read /var/db/SystemPolicy-prefs.plist enabled
defaults read com.apple.LaunchServices LSQuarantine

fancy_echo "Disabling OS X Crash Reporter"
defaults read com.apple.CrashReporter DialogType none
# launchctl unload -w /System/Library/LaunchAgents/com.apple.ReportCrash.plist
# sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.ReportCrash.Root.plist

fancy_echo "Increasing the window resize speed for Cocoa applications"
defaults read NSGlobalDomain NSWindowResizeTime

fancy_echo "Expanding the save panel by default"
defaults read NSGlobalDomain NSNavPanelExpandedStateForSaveMode
defaults read NSGlobalDomain PMPrintingExpandedStateForPrint
defaults read NSGlobalDomain PMPrintingExpandedStateForPrint2

fancy_echo "Automatically quit printer app once the print jobs complete"
defaults read com.apple.print.PrintingPrefs "Quit When Finished"

# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
fancy_echo "Displaying ASCII control characters using caret notation in standard text views"
defaults read NSGlobalDomain NSTextShowsControlCharacters

# I like my terminal resume too much...
#echo ""
#echo "Disabling system-wide resume"
defaults read NSGlobalDomain NSQuitAlwaysKeepsWindows

fancy_echo "Disabling automatic termination of inactive apps"
defaults read NSGlobalDomain NSDisableAutomaticTermination

fancy_echo "Saving to disk (not to iCloud) by default"
defaults read NSGlobalDomain NSDocumentSaveNewDocumentsToCloud

fancy_echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
defaults read /Library/Preferences/com.apple.loginwindow

# echo ""
# echo "Never go into computer sleep mode"
# systemsetup -setcomputersleep Off > /dev/null

fancy_echo "Check for software updates daily, not just once per week"
defaults read com.apple.SoftwareUpdate ScheduleFrequency

fancy_echo "Disable smart quotes and smart dashes as they're annoying when typing code"
defaults read NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled
defaults read NSGlobalDomain NSAutomaticDashSubstitutionEnabled


###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
###############################################################################

fancy_echo "Increasing sound quality for Bluetooth headphones/headsets"
defaults read com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)"

fancy_echo "Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults read NSGlobalDomain AppleKeyboardUIMode

fancy_echo "Disabling press-and-hold for keys in favor of a key repeat"
defaults read NSGlobalDomain ApplePressAndHoldEnabled

fancy_echo "Setting a blazingly fast keyboard repeat rate (ain't nobody got time fo special chars while coding!)"
defaults read NSGlobalDomain KeyRepeat

fancy_echo "Disabling auto-correct"
defaults read NSGlobalDomain NSAutomaticSpellingCorrectionEnabled

fancy_echo "Setting trackpad & mouse speed to a reasonable number"
defaults read -g com.apple.trackpad.scaling
defaults read -g com.apple.mouse.scaling

fancy_echo "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults read com.apple.BezelServices kDimTime

###############################################################################
# Screen
###############################################################################

fancy_echo "Requiring password immediately after sleep or screen saver begins"
defaults read com.apple.screensaver askForPassword
defaults read com.apple.screensaver askForPasswordDelay

fancy_echo "Enabling subpixel font rendering on non-Apple LCDs"
defaults read NSGlobalDomain AppleFontSmoothing

fancy_echo "Enable HiDPI display modes (requires restart)"
defaults read /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled


###############################################################################
# Finder
###############################################################################

fancy_echo "Showing icons for hard drives, servers, and removable media on the desktop"
defaults read com.apple.finder ShowExternalHardDrivesOnDesktop

fancy_echo "Showing all filename extensions in Finder by default"
defaults read NSGlobalDomain AppleShowAllExtensions

fancy_echo "Showing status bar in Finder by default"
defaults read com.apple.finder ShowStatusBar

fancy_echo "Allowing text selection in Quick Look/Preview in Finder by default"
defaults read com.apple.finder QLEnableTextSelection

fancy_echo "Displaying full POSIX path as Finder window title"
defaults read com.apple.finder _FXShowPosixPathInTitle

fancy_echo "Disabling the warning when changing a file extension"
defaults read com.apple.finder FXEnableExtensionChangeWarning

fancy_echo "Use column view in all Finder windows by default"
defaults read com.apple.finder FXPreferredViewStyle Clmv

fancy_echo "Avoiding the creation of .DS_Store files on network volumes"
defaults read com.apple.desktopservices DSDontWriteNetworkStores

fancy_echo "Disabling disk image verification"
defaults read com.apple.frameworks.diskimages skip-verify
defaults read com.apple.frameworks.diskimages skip-verify-locked
defaults read com.apple.frameworks.diskimages skip-verify-remote

fancy_echo "Enabling snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Print :DesktopViewSettings:IconViewSettings:arrangeBy" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Print :FK_StandardViewSettings:IconViewSettings:arrangeBy" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Print :StandardViewSettings:IconViewSettings:arrangeBy" ~/Library/Preferences/com.apple.finder.plist


fancy_echo "Disable disk image verification"
defaults read com.apple.frameworks.diskimages skip-verify
defaults read com.apple.frameworks.diskimages skip-verify-locked
defaults read com.apple.frameworks.diskimages skip-verify-remote

fancy_echo "Automatically open a new Finder window when a volume is mounted"
defaults read com.apple.frameworks.diskimages auto-open-ro-root
defaults read com.apple.frameworks.diskimages auto-open-rw-root
defaults read com.apple.finder OpenWindowForNewRemovableDisk

fancy_echo "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults read com.apple.finder FXPreferredViewStyle


fancy_echo "Disable the warning before emptying the Trash"
defaults read com.apple.finder WarnOnEmptyTrash

fancy_echo "Empty Trash securely by default"
defaults read com.apple.finder EmptyTrashSecurely


###############################################################################
# Dock & Mission Control
###############################################################################

fancy_echo "Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don't use
# the Dock to launch apps.
# defaults read com.apple.dock persistent-apps -array

fancy_echo "Setting the icon size of Dock items to 36 pixels for optimal size/screen-realestate"
defaults read com.apple.dock tilesize

fancy_echo "Speeding up Mission Control animations and grouping windows by application"
defaults read com.apple.dock expose-animation-duration
defaults read com.apple.dock "expose-group-by-app"

fancy_echo "Setting Dock to auto-hide and removing the auto-hiding delay"
defaults read com.apple.dock autohide
defaults read com.apple.dock autohide-delay
defaults read com.apple.dock autohide-time-modifier

fancy_echo "Enable spring loading for all Dock items"
defaults read com.apple.dock enable-spring-load-actions-on-all-items

fancy_echo "Show indicator lights for open applications in the Dock"
defaults read com.apple.dock show-process-indicators

fancy_echo "Wipe all (default) app icons from the Dock"
# This is only really useful when setting up a new Mac, or if you don't use
# the Dock to launch apps.
# defaults read com.apple.dock persistent-apps -array

fancy_echo "Don't animate opening applications from the Dock"
defaults read com.apple.dock launchanim

fancy_echo "Make Dock icons of hidden applications translucent"
defaults read com.apple.dock showhidden

fancy_echo "Speed up Mission Control animations"
defaults read com.apple.dock expose-animation-duration

fancy_echo "Don't group windows by application in Mission Control"
fancy_echo "(i.e. use the old Expose behavior instead)"
defaults read com.apple.dock expose-group-by-app

fancy_echo "Disable Dashboard"
defaults read com.apple.dashboard mcx-disabled

fancy_echo "Don't show Dashboard as a Space"
defaults read com.apple.dock dashboard-in-overlay

fancy_echo "Don't automatically rearrange Spaces based on most recent use"
defaults read com.apple.dock mru-spaces




###############################################################################
# Safari & WebKit
###############################################################################

fancy_echo "Hiding Safari's bookmarks bar by default"
defaults read com.apple.Safari ShowFavoritesBar

fancy_echo "Hiding Safari's sidebar in Top Sites"
defaults read com.apple.Safari ShowSidebarInTopSites

fancy_echo "Disabling Safari's thumbnail cache for History and Top Sites"
defaults read com.apple.Safari DebugSnapshotsUpdatePolicy

fancy_echo "Enabling Safari's debug menu"
defaults read com.apple.Safari IncludeInternalDebugMenu

fancy_echo "Making Safari's search banners default to Contains instead of Starts With"
defaults read com.apple.Safari FindOnPageMatchesWordStartsOnly

fancy_echo "Removing useless icons from Safari's bookmarks bar"
defaults read com.apple.Safari ProxiesInBookmarksBar "()"

fancy_echo "Allow hitting the Backspace key to go to the previous page in history"
defaults read com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled

fancy_echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults read com.apple.Safari IncludeDevelopMenu
defaults read com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey
defaults read com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled"

fancy_echo "Adding a context menu item for showing the Web Inspector in web views"
defaults read NSGlobalDomain WebKitDeveloperExtras


###############################################################################
# Mail
###############################################################################

fancy_echo "Setting email addresses to copy as 'foo@example.com' instead of 'Foo Bar <foo@example.com>' in Mail.app"
defaults read com.apple.mail AddressesIncludeNameOnPasteboard


###############################################################################
# Terminal
###############################################################################

fancy_echo "Enabling UTF-8 ONLY in Terminal.app and setting the Pro theme by default"
# defaults read com.apple.terminal StringEncodings -array 4

# echo ""
# echo "Terminal.app: setting the Pro theme by default"
# defaults read com.apple.Terminal "Default Window Settings" -string "Pro"
# defaults read com.apple.Terminal "Startup Window Settings" -string "Pro"

###############################################################################
# Time Machine
###############################################################################

fancy_echo "Preventing Time Machine from prompting to use new hard drives as backup volume"
defaults read com.apple.TimeMachine DoNotOfferNewDisksForBackup

fancy_echo "Disabling local Time Machine backups"
# hash tmutil &> /dev/null && sudo tmutil disablelocal


###############################################################################
# Messages                                                                    #
###############################################################################

fancy_echo "Disable automatic emoji substitution (i.e. use plain text smileys)"
defaults read com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage"

fancy_echo "Disable smart quotes as it's annoying for messages that contain code"
defaults read com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled"

fancy_echo "Disable continuous spell checking"
defaults read com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled"

###############################################################################
# Activity Monitor                                                            #
###############################################################################

fancy_echo "Show the main window when launching Activity Monitor"
defaults read com.apple.ActivityMonitor OpenMainWindow

fancy_echo "Visualize CPU usage in the Activity Monitor Dock icon"
defaults read com.apple.ActivityMonitor IconType

fancy_echo "Show all processes in Activity Monitor"
defaults read com.apple.ActivityMonitor ShowCategory

fancy_echo "Sort Activity Monitor results by CPU usage"
defaults read com.apple.ActivityMonitor SortColumn
defaults read com.apple.ActivityMonitor SortDirection


###############################################################################
# Personal Additions
###############################################################################

# echo ""
# echo "Disable hibernation (speeds up entering sleep mode)"
# sudo pmset -a hibernatemode 0

# echo ""
# echo "Remove the sleep image file to save disk space"
# sudo rm /Private/var/vm/sleepimage
# echo "Creating a zero-byte file insteadâ€¦"
# sudo touch /Private/var/vm/sleepimage
# echo "â€¦and make sure it can't be rewritten"
# sudo chflags uchg /Private/var/vm/sleepimage

fancy_echo "Disable the sudden motion sensor as it's not useful for SSDs"
# sudo pmset -a sms 0

fancy_echo "Speeding up wake from sleep to 12 hours from an hour"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
# sudo pmset -a standbydelay 43200 

# echo ""
# echo "Disable computer sleep and stop the display from shutting off"
# sudo pmset -a sleep 0
# sudo pmset -a displaysleep 0

fancy_echo "Disable annoying backswipe in Chrome"
defaults read com.google.Chrome AppleEnableSwipeNavigateWithScrolls

fancy_echo "Use the system-native print preview dialog in Chrome"
defaults read com.google.Chrome DisablePrintPreview
defaults read com.google.Chrome.canary DisablePrintPreview


fancy_echo "Disable the sound effects on boot"
# sudo nvram SystemAudioVolume=" "



###############################################################################
# Kill affected applications
###############################################################################

echo "Done!"