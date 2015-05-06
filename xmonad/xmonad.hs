-- Import statements
import XMonad
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Actions.CycleWS
import XMonad.Layout.Spacing
import XMonad.Layout.Minimize
import Graphics.X11.ExtraTypes.XF86
import Control.Monad
import qualified Data.Map as M
import qualified XMonad.StackSet as W

-- Workspaces
myWorkspaces = ["1","2","3","4","5","6","7"]

-- Define the workspace an app goes to
myManageHook = composeAll . concat $
  [
      [ className =? a --> viewShift "2"     | a <- myClassWebShifts ]
    , [ className =? b --> viewShift "3"     | b <- myClassChatShifts ]
    , [ className =? c --> doF (W.shift "4") | c <- myClassOtherShifts ]
    , [ className =? d --> doFloat           | d <- myClassFloats ]
  ]
  where
    viewShift = doF . liftM2 (.) W.greedyView W.shift
    myClassWebShifts    = ["Google-chrome-stable", "Firefox"]
    myClassChatShifts   = ["Skype", "Steam"]
    myClassOtherShifts  = []
    myClassFloats       = []

-- Keys to add
keysToAdd x =
  [
    ((mod4Mask, xK_Left), spawn "xbacklight -dec 10")
    , ((mod4Mask, xK_Right), spawn "xbacklight -inc 10")
    , ((mod4Mask .|. mod1Mask, xK_Left), spawn "xbacklight -inc 5")
    , ((mod4Mask .|. mod1Mask, xK_Right), spawn "xbacklight -dec 5")
    , ((mod4Mask .|. mod1Mask, xK_z), shiftToPrev)
    , ((mod4Mask .|. mod1Mask, xK_x), shiftToNext)
    , ((mod4Mask, xK_z), prevWS)
    , ((mod4Mask, xK_x), nextWS)
    , ((0, xF86XK_AudioRaiseVolume  ), spawn "amixer set Master 3%+")
    , ((0, xF86XK_AudioLowerVolume  ), spawn "amixer set Master 3%-")
    , ((0, xF86XK_AudioMute         ), spawn "amixer set Master toggle")
    , ((mod1Mask, xK_c), kill)
    , ((mod1Mask, xK_r), spawn "xmonad --recompile")
    , ((mod4Mask, xK_g), spawn "google-chrome-stable")
    , ((mod4Mask, xK_f), spawn "firefox")
    , ((mod4Mask, xK_t), spawn "gnome-terminal")
    , ((mod4Mask, xK_s), spawn "skype")
    , ((mod4Mask, xK_n), spawn "dmenu_run")
    , ((mod4Mask, xK_m), withFocused minimizeWindow)
    , ((mod4Mask .|. mod1Mask, xK_m), sendMessage RestoreNextMinimizedWin)
  ]

-- Keys to remove
keysToRemove x = [ (modMask x .|. shiftMask, xK_p) ]

-- Delete keys
strippedKeys x = foldr M.delete (keys defaultConfig x) (keysToRemove x)
-- Compose new key combonations
myKeys x = M.union (strippedKeys x) (M.fromList (keysToAdd x))

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
  where fadeAmount = 0.9

myLayout = minimize $ tiled ||| Mirror tiled ||| Full  
  where  
    -- default tiling algorithm partitions the screen into two panes  
    tiled = spacing 2 $ Tall nmaster delta ratio  
    -- The default number of windows in the master pane  
    nmaster = 1  
    -- Default proportion of screen occupied by master pane  
    ratio = 1/2  
    -- Percent of screen to increment by when resizing panes  
    delta = 5/100 

-- Run XMonad
main = xmonad =<< xmobar defaultConfig {
        terminal      = "gnome-terminal"
      , workspaces    = myWorkspaces
      , manageHook    = myManageHook
      , layoutHook    = myLayout
      , logHook       = myLogHook
      , focusedBorderColor = "#000000"
      , keys          = myKeys
  }


--xmonad --recompile
--xmonad --restart

