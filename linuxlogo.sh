#!/bin/sh

# ANSI Color -- use these variables to easily have different color
#    and format output. Make sure to output the reset sequence after 
#    colors (f = foreground, b = background), and use the 'off'
#    feature for anything you turn on.

initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"

  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

hrz='──────────'
spc='          '

# note in this first use that switching colors doesn't require a reset
# first - the new color overrides the old one.

initializeANSI

cat << EOF



${boldon}${blackf}${blueb}         ${reset}      ${blueb}       ${reset}${whitef}${reset}
${boldon}${blackf}${blueb}        ${boldoff}${reset}        ${blueb}      ${reset}${whitef}${reset}  ${boldon}${redb}   ${reset}${reset} ${boldon}${redb} ${reset}${reset}   ${boldon}${redb} ${reset}${reset} ${boldon}${redb} ${reset}${reset}  ${boldon}${redb} ${reset}${reset}     ${boldon}${greenf}${greenb} ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}     ${boldon}${blackf}${whiteb}      ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}
${blueb}        ${reset} ${whiteb}  ${reset} ${whiteb}  ${reset}  ${blueb}      ${reset}${whitef}${reset} ${boldon}${redb} ${reset}${reset}    ${boldon}${redb}  ${reset}${reset}  ${boldon}${redb} ${reset}${reset} ${boldon}${redb} ${reset}${reset}  ${boldon}${redb} ${reset}${reset}    ${boldon}${greenf}${greenb} ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}       ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}   ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}    ${reset}${whitef}${reset} ${reset}
${boldon}${blackf}${blueb}        ${reset} ${whiteb} ${reset}   ${whiteb} ${reset}   ${blueb}     ${reset}${whitef}${reset} ${boldon}${redb} ${reset}${reset} ${boldon}${redb}  ${reset}${reset} ${boldon}${redb} ${reset}${reset} ${boldon}${redb} ${reset}${reset} ${boldon}${redb} ${reset}${reset} ${boldon}${redb} ${reset}${reset}  ${boldon}${redb} ${reset}${reset}   ${boldon}${greenf}${greenb} ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}       ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}    ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}  ${reset}
${boldon}${blackf}${blueb}        ${reset}  ${yellowb}    ${reset}   ${blueb}     ${reset}${whitef}${reset} ${boldon}${redb} ${reset}${reset}  ${boldon}${redb} ${reset}${reset} ${boldon}${redb} ${reset}${reset}  ${boldon}${redb}  ${reset}${reset} ${boldon}${redb} ${reset}${reset}  ${boldon}${redb} ${reset}${reset}  ${boldon}${greenf}${greenb} ${reset}${whitef}${reset}    ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}       ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}    ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}    ${reset}${whitef}${reset}
${boldon}${blackf}${blueb}        ${reset} ${reset}${blackf}${yellowb}\`----'${reset}  ${boldon}${blueb}     ${reset}${whitef}${reset}  ${boldon}${redb}   ${reset}${reset} ${boldon}${redb} ${reset}${reset}   ${boldon}${redb} ${reset}${reset}  ${boldon}${redb}  ${reset}${reset}  ${boldon}${greenf}${greenb} ${reset}${whitef}${reset}     ${boldon}${blackf}${whiteb}      ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}      ${reset}${whitef}${reset} ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}   ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}    ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}  ${boldon}${blackf}${whiteb}  ${reset}${whitef}${reset}
${blueb}        ${reset} ${whiteb} ${whitef}    ${blackf} ${reset}   ${blueb}    ${reset}${whitef}${reset}
${boldon}${blackf}${blueb}       ${reset} ${whiteb}        ${reset}    ${blueb}  ${reset}${whitef} ┌──${hrz}${hrz}${hrz}${hrz}${hrz}──┐
${boldon}${blackf}${blueb}       ${reset} ${whiteb}         ${reset}    ${blueb} ${reset}${whitef} │  ${spc}${spc}${spc}${spc}${spc}  │
${boldon}${blackf}${blueb}       ${reset} ${whiteb}         ${reset}    ${blueb} ${reset}${whitef} │  @imjoseangel                                        │
${boldon}${blackf}${blueb}      ${reset} ${whiteb}          ${reset}     ${reset}${whitef} │  MacBook Air (Retina, 13-inch, 2019)                 │
${boldon}${blackf}${blueb}     ${reset}  ${whiteb}          ${reset}     ${reset}${whitef} │  Processor: 1.6 GHz Dual-Core Intel Core i5          │
${boldon}${blackf}${blueb}     ${yellowb}   ${whiteb}        ${yellowb}   ${reset}   ${reset}${whitef} │  Memory: 16 GB 2133 MHz LPDDR3                       │
${boldon}${blackf}${blueb}   ${yellowb}     ${whiteb}        ${yellowb}    ${reset}  ${reset}${whitef} │  Graphics: Intel UHD Graphics 617 1536 MB            │
${boldon}${blackf}${blueb} ${yellowb}       ${whiteb}        ${yellowb}      ${reset}${whitef} │  ${spc}${spc}${spc}${spc}${spc}  │
${boldon}${blackf}${blueb} ${yellowb}       ${reset} ${whiteb}      ${reset} ${yellowb}      ${reset}${whitef} └──${hrz}${hrz}${hrz}${hrz}${hrz}──┘



EOF
