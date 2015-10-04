import XMonad
import XMonad.Prompt
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.WorkspaceDir
import System.IO

myLayout = workspaceDir "~" (avoidStruts $ layoutHook defaultConfig)

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/.xmobarrc"
  xmonad $ defaultConfig
    { terminal = "urxvt"
    , manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = myLayout
    , logHook = dynamicLogWithPP xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "green" "" . shorten 50
      }
    } `additionalKeys`
    [ ((mod1Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((0, xK_Print), spawn "scrot")
    , ((mod1Mask .|. shiftMask, xK_x), changeDir defaultXPConfig)
    ]
