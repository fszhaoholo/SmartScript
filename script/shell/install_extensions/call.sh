#!/bin/bash

# installed extension list
# extension_list=(austin.code-gnu-global
# CoenraadS.bracket-pair-colorizer
# danielpinto8zz6.c-cpp-compile-run
# donjayamanne.githistory
# EditorConfig.EditorConfig
# gayanhewa.referenceshelper
# huizhou.githd
# IBM.output-colorizer
# ms-python.python
# ms-vscode.cpptools
# redhat.vscode-yaml
# twxs.cmake
# vector-of-bool.cmake-tools)
extension_list=(dbaeumer.vscode-eslint
streetsidesoftware.code-spell-checker)

echo ${extension_list[@]}

for item in ${extension_list[@]}
do
    ./install_extensions.sh $item
done