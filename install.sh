##########################################################################################
# Config Flags
##########################################################################################

# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
# REPLACE_EXAMPLE="
# /system/app/Youtube
# /system/priv-app/SystemUI
# /system/priv-app/Settings
# /system/framework
# "

# Construct your own list here
REPLACE=""

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################x

# Set what you want to display when installing your module
Market_Name=`getprop ro.product.marketname`
Device=`getprop ro.product.device`
Version=`getprop ro.build.version.incremental`
Android=`getprop ro.build.version.release`
CPU_ABI=`getprop ro.product.cpu.abi`
print_modname() {
    ui_print " Uperf-dev（Modify power consumption model） "
    ui_print
    ui_print " 模块作者：@Matt Yang & Coolapk @卷猫 Modify  " 
    ui_print " 设备型号：$Market_Name"
    ui_print " 设备代号：$Device"
    ui_print " 安卓版本：Android $Android"
    ui_print " 系统版本：$Version"
    ui_print " CPU架构：$CPU_ABI"
    ui_print "*******************************"
    ui_print " "
    ui_print " 重铸888……       算了，养老！"
    ui_print " "
    ui_print " ⚠️ 注意 ⚠️"
    ui_print " 本模块仅为个人学习研究之目的使用。"
    ui_print " 效果可能不尽如人意，不保证产生良好的结果。"
    ui_print " 欲让您基于火龙888平台的 $Market_Name（$Device） 有更好的使用体验，您应当选用知名人士的调度，如SCENE在线，原版Uperf。"
    ui_print
    return
}

# Copy/extract your module files into $MODPATH in on_install.
on_install() {
    $BOOTMODE || abort "! Uperf cannot be installed in recovery."
    [ $ARCH == "arm64" ] || abort "! Uperf ONLY support arm64 platform."
    ui_print "- Extracting module files"
    unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >/dev/null

    # use universal setup.sh
    sh $MODPATH/script/setup.sh
    [ "$?" != "0" ] && abort
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases
set_permissions() {
    return
}

# You can add more functions to assist your custom script code
