-- generated from the tutorial at:
-- http://www.haskell.org/haskellwiki/Xmonad/Config_archive/John_Goerzen%27s_Configuration

import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FloatNext
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Maximize
import XMonad.Layout.ThreeColumns
import XMonad.Layout.PerScreen
import XMonad.Util.EZConfig
import XMonad.Layout.Reflect
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.Spacing
import XMonad.Layout.NoFrillsDecoration
import qualified XMonad.StackSet as W
import XMonad.Layout.Minimize
import XMonad.Actions.UpdatePointer

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    ]

main = do
   xmproc <- spawnPipe "xmobar"
   xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
    { manageHook = manageDocks
                   <+> myManageHook
                   <+> manageHook defaultConfig,
      layoutHook = minimize $ maximize $ avoidStruts $ ifWider 3000 ((ThreeColMid 1 (3/100) (1/3)) ||| (reflectHoriz $ Tall 1 (3/100) (2/3))) (Tall 1 (3/100) (2/3)) |||  layoutHook defaultConfig,
--      layoutHook = minimize $ maximize $ avoidStruts $ (ThreeColMid 1 (3/100) (1/3)) ||| (reflectHoriz $ Tall 1 (3/100) (1/2)) |||  layoutHook defaultConfig,
      -- Without this, when xmonad is started or restarted, the xmobar on the startup workspace will get covered by any applications.
      handleEventHook = mconcat
                        [ docksEventHook
                         ,handleEventHook defaultConfig ],
      logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc,
                      ppTitle = xmobarColor "green" "" . shorten 50,
                      ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                    } >> updatePointer (0.1, 0.1) (0.1, 0.1),
      modMask = mod4Mask,
      terminal = "gnome-terminal",
      startupHook = mystartupHook,
--      focusedBorderColor = "#268bd2",
      focusedBorderColor = "#42f4eb",
      borderWidth = 3
    } `additionalKeysP` myKeys
 
myKeys = 
    [ ("M-\\", withFocused (sendMessage . maximizeRestore))
    -- M1 is left alt. See output of command `xmodmap`.
    -- https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Util-EZConfig.html
     ,("C-M1-l", spawn "cinnamon-screensaver-command -l")
     ,("M-m", withFocused minimizeWindow)
     ,("M-S-m", sendMessage RestoreNextMinimizedWin)
    ]
    ++
    -- See PhysicalScreens here: https://wiki.haskell.org/Xmonad/Frequently_asked_questions
    [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
         | (key, scr)  <- zip "wer" [0,1,2] -- was [0..] *** change to match your screen order ***
         , (action, mask) <- [ (W.view, "") , (W.shift, "S-")]
    ]

mystartupHook = do
  startupHook defaultConfig
--  spawn "/usr/bin/xcompmgr"     -- Nvidia issue: b/12995284
