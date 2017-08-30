; Copyright (C) 2017 Altynbek Isabekov, Onurhan Öztürk

; Prometheus-Installer is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 2 of the License, or
; (at your option) any later version.

; Prometheus-Installer is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License v2.0 for more details.

!include "x64.nsh"
!include "MUI2.nsh"
; Support for UTF16LE encoding
Unicode true

; Set compression type
SetCompressor /SOLID lzma

!define FILE_NAME 'Prometheus'
!define FILE_VERSION '1.0'
!define FILE_INSTVERSION '2017.01.04'
!define FILE_OWNER 'Prometheus FPGA'
!define APP_URL 'http://www.prometheus-fpga.com'
!define APPNAME "Prometheus"
!define CMDAPPNAME "fireprog"
!define COMPANYNAME "Koç University"
;!define DESCRIPTION "A utility to program Prometheus FPGA board"
BrandingText '${FILE_OWNER}'
!define OUTFILENAME "${APPNAME}-Installer-32-bit.exe"
OutFile "${OUTFILENAME}"
; These three must be integers
!define VERSIONMAJOR 1
!define VERSIONMINOR 1
!define VERSIONBUILD 1

; These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
; It is possible to use "mailto:" links in here to open the email client
!define HELPURL   "${APP_URL}" ; "Support Information" link
!define UPDATEURL "${APP_URL}" ; "Product Updates" link
!define ABOUTURL  "${APP_URL}" ; "Publisher" link

; Installation directory to be offered in MUI_PAGE_DIRECTORY dialog
InstallDir "$PROGRAMFILES\${APPNAME}"

; Adde meta-data information to an executable
VIAddVersionKey "ProductName" '${FILE_NAME}'
VIAddVersionKey "ProductVersion" '${FILE_VERSION}'
VIAddVersionKey "CompanyName" '${COMPANYNAME}'
VIAddVersionKey "LegalCopyright" 'Altynbek Isabekov, Onurhan Öztürk'
VIAddVersionKey "FileDescription" 'An installer for "${FILE_NAME}.exe" and "${CMDAPPNAME}.exe"'
VIAddVersionKey "FileVersion" '${FILE_INSTVERSION}'
VIAddVersionKey "OriginalFileName" '${OUTFILENAME}'
VIProductVersion '1.0.0.0'

; Registry entries
!define REGKEY_APP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${APPNAME}.exe"
!define REGKEY_CMDAPP_PATH "Software\Microsoft\Windows\CurrentVersion\App Paths\${CMDAPPNAME}.exe"
!define REGKEY_UNINST   "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"


; This is the size (in kB) of all the files copied into "Program Files"
;!define INSTALLSIZE 7233


;!define MUI_LANGDLL_INFO "Please select a language"
;!define MUI_LANGDLL_WINDOWTITLE "Prometheus: Choose Language"

!define MUI_ABORTWARNING
!define ICON_FILE "Icon.ico"
!define MUI_ICON "Images/${ICON_FILE}"
!define MUI_UNICON "Images/nsis1-uninstall.ico"

; This will be in the installer/uninstaller's title bar
Name "${APPNAME}"
Icon ${MUI_ICON}



;!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"

; Can be customized but needs support for all languages
;!define MUI_WELCOMEPAGE_TITLE "Welcome to ${APPNAME} Setup!"
;!define MUI_WELCOMEPAGE_TITLE_3LINES
;!define MUI_WELCOMEPAGE_TEXT "Setup will guide you through the installation of ${APPNAME}. $\n$\nIt is recommended that you close all other applications before starting Setup. This will make it possible to update relevant system files without having to reboot your computer. $\n$\nClick $\"Next$\" to continue."

; Welcome image's size should be 164x314 pixels (width x height)
!define MUI_WELCOMEFINISHPAGE_BITMAP "Images/Prometheus.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Images/Prometheus.bmp"


; Header image's size should be 150x57 pixels (width x height)
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "Images/HeaderOrange.bmp"
!define MUI_COMPONENTSPAGE_TEXT_TOP "Check the components you want to install and uncheck the components you dont want to install. Cleck $\"Next$\" to continue."
!define MUI_COMPONENTSPAGE_TEXT_COMPLIST "Select components to install"
!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_TITLE "Description"
!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_INFO "Position your mouse over a component to see its description"
;!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT
!define MUI_FINISHPAGE_NOAUTOCLOSE
;!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_STARTMENUPAGE
!define MUI_STARTMENU_DEFAULTFOLDER "${APPNAME}"
!insertmacro MUI_PAGE_WELCOME
!define LICENSE_FILE "License.txt"
!insertmacro MUI_PAGE_LICENSE "License/${LICENSE_FILE}"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; =============================================================
; Use $STARTMENU_GROUP since it is a variable. Do not use ${STARTMENU_GROUP}!
var "STARTMENU_GROUP"
!insertmacro MUI_PAGE_STARTMENU Application  "$STARTMENU_GROUP"
; =============================================================

!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "GNUstep\Apps"


!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Run Prometheus"
!define MUI_FINISHPAGE_RUN_FUNCTION "LaunchPrometheus"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!insertmacro MUI_PAGE_FINISH


!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH
;--------------------------------
;Languages
!insertmacro MUI_LANGUAGE "English"
;!insertmacro MUI_LANGUAGE "German"

;--------------------------------
; INSTALL TYPES (Where I placed the Installation Types)
;--------------------------------
InstType "Full Installation Mode"
InstType "Partial Installation Mode"
InstType /NOCUSTOM



!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

Function .onInit
    ${If} ${RunningX64}
        ; Comment out this next line in production environment
        MessageBox MB_OK "This is a 64-bit OS, but 32-bit applications will be installed. Choose $\"C:\Program Files (x86)$\" as the destination directory in the next steps. Press $\"OK$\" to continue."
        SetRegView 64
        ;StrCpy $INSTDIR "$PROGRAMFILES64\My FooBar Application"
    ${EndIf}
  ;!insertmacro MUI_LANGDLL_DISPLAY
  ;	setShellVarContext all
  !insertmacro VerifyUserIsAdmin
FunctionEnd


;Require admin rights on NT6+ (When UAC is turned on)
RequestExecutionLevel admin

; ================================= Installer =================================

Section "Install programs" SEC01
	SectionIn RO 1 2
	; Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	SetOutPath $INSTDIR
	; Files added here should be removed by the uninstaller (see section "Uninstall")
	File "Exe/${APPNAME}.exe"
	File "Exe/${CMDAPPNAME}.exe"
	File "${MUI_ICON}"
	File "License/${LICENSE_FILE}"

	CreateDirectory "$INSTDIR\BitFiles"
	SetOutPath "$INSTDIR\BitFiles"
	File "BitFiles/bscan_spi.bit"

	WriteIniStr "$INSTDIR\${APPNAME}.url" "InternetShortcut" "URL" "${APP_URL}"

	; Uninstaller - See function un.onInit and section "Uninstall" for configuration
	writeUninstaller "$INSTDIR\Uninstall.exe"

	; Add any other files for the install directory (license files, app data, etc) here
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        ; Start Menu
        CreateDirectory "$SMPROGRAMS\$STARTMENU_GROUP"
        CreateShortCut "$SMPROGRAMS\$STARTMENU_GROUP\${APPNAME}.lnk" "$INSTDIR\${APPNAME}.exe" "$INSTDIR\${ICON_FILE}"
        CreateShortCut "$SMPROGRAMS\$STARTMENU_GROUP\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
        CreateShortCut "$SMPROGRAMS\$STARTMENU_GROUP\License.lnk" "$INSTDIR\${LICENSE_FILE}"
        CreateShortCut "$SMPROGRAMS\$STARTMENU_GROUP\Website.lnk" "$INSTDIR\${APPNAME}.url"
    !insertmacro MUI_STARTMENU_WRITE_END

    WriteRegStr HKLM "${REGKEY_APP_PATH}" "Path" "$INSTDIR"
    WriteRegStr HKLM "${REGKEY_APP_PATH}" "" "$INSTDIR\${APPNAME}.exe"
    WriteRegStr HKLM "${REGKEY_CMDAPP_PATH}" "" "$INSTDIR\${CMDAPPNAME}.exe"
    WriteRegStr HKLM "${REGKEY_CMDAPP_PATH}" "Path" "$INSTDIR"
	; Registry information for add/remove programs
	WriteRegStr HKLM "${REGKEY_UNINST}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "${REGKEY_UNINST}" "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "${REGKEY_UNINST}" "QuietUninstallString" "$\"$INSTDIR\Uninstall.exe$\" /S"
	WriteRegStr HKLM "${REGKEY_UNINST}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "${REGKEY_UNINST}" "DisplayIcon" "$\"$INSTDIR\${ICON_FILE}$\""
	WriteRegStr HKLM "${REGKEY_UNINST}" "Publisher" "${COMPANYNAME}"
	WriteRegStr HKLM "${REGKEY_UNINST}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "${REGKEY_UNINST}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "${REGKEY_UNINST}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "${REGKEY_UNINST}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "${REGKEY_UNINST}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "${REGKEY_UNINST}" "VersionMinor" ${VERSIONMINOR}
	; There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "${REGKEY_UNINST}" "NoModify" 1
	WriteRegDWORD HKLM "${REGKEY_UNINST}" "NoRepair" 1
	; Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	;WriteRegDWORD HKLM "${REGKEY_UNINST}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd


Section "Install test files" SEC02
  SectionIn 1
  ; Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	SetOutPath "$INSTDIR\BitFiles"
	File "BitFiles/Button2LED.bit"
	File "BitFiles/Clock.bit"
	File "BitFiles/Sliding_LED.bit"
	; Files added here should be removed by the uninstaller (see section "Uninstall")
	; Add any other files for the install directory (license files, app data, etc) here
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        ; Start Menu
		CreateShortCut "$SMPROGRAMS\$STARTMENU_GROUP\Bit Files.lnk" "$INSTDIR\BitFiles"
    !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd


LangString DESC_Section1 ${LANG_ENGLISH} "Install $\"Prometheus$\" (a GUI) and $\"fireprog$\" (a command line utility). Create shortcuts to these programs in the Start Menu."
LangString DESC_Section2 ${LANG_ENGLISH} "Install additional $\".bit$\" test files."
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} $(DESC_Section1)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} $(DESC_Section2)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

; Called if Run Editra is checked on the last page of installer
Function LaunchPrometheus
  Exec '"$INSTDIR\${APPNAME}.exe"'
FunctionEnd

; ================================= Uninstaller =================================

Function un.onInit
    ${If} ${RunningX64}
        ; Comment out this next line in production environment
        SetRegView 64
        ;StrCpy $INSTDIR "$PROGRAMFILES64\My FooBar Application"
    ${EndIf}
;    !insertmacro MUI_LANGDLL_DISPLAY
;	SetShellVarContext all
;	;Verify the uninstaller - last chance to back out
;	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
;		Abort
;	next:
;	!insertmacro VerifyUserIsAdmin
FunctionEnd

Section "Uninstall"
    !insertmacro MUI_STARTMENU_GETFOLDER "Application" $STARTMENU_GROUP
	; Remove Start Menu launcher
	rmDir /r "$SMPROGRAMS\$STARTMENU_GROUP"

	; Try to remove the install directory
	rmDir /r "$INSTDIR"

	; Remove uninstaller information from the registry
	DeleteRegKey HKLM "${REGKEY_UNINST}"
	DeleteRegKey HKLM "${REGKEY_APP_PATH}"
	DeleteRegKey HKLM "${REGKEY_CMDAPP_PATH}"
SectionEnd
