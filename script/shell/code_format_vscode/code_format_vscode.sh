#!/bin/bash

user_setting_path="$HOME/.config/Code/User/"
setting_name="settings.json"

whole_setting_path=$user_setting_path$setting_name
echo $whole_setting_path

# used to store .clang-format and .editorconfig
user_path="$HOME/"

#get the extension list on the computer
cmd_code_extension_list="code --list-extensions"
extension_list=`${cmd_code_extension_list}`
echo $extension_list

if [[ ! $extension_list =~ .*ms-vscode.cpptools.* ]]
then
    #install c/c++ extension
    cmd="code --install-extension ms-vscode.cpptools"
    ${cmd}
fi

if [[ ! $extension_list =~ .*EditorConfig.EditorConfig.* ]]
then
    #install EditorConfig.EditorConfig extension
    cmd="code --install-extension EditorConfig.EditorConfig"
    ${cmd}
fi

if [ ! -f "${user_path}.clang-format" ];then
    #copy clang-format configuration to ~/ directory, 
    #so that all vscode workspace could use it
    echo "copy clang-format to ${user_path}"
    cmd="cp .clang-format ${user_path}"
    ${cmd}
else
    echo "you already had a .clang-format file in $user_path directory."
    echo "please check if it is valid"

fi

if [ ! -f "${user_path}.editorconfig" ];then
    #copy editorconfig configuration to ~/ directory, 
    #so that all vscode workspace could use it
    echo "copy editorconfig to ${user_path}"
    cmd="cp .editorconfig ${user_path}"
    ${cmd}
else
    echo "you already had a .editorconfig file in $user_path directory."
    echo "please check if it is valid"
fi

# c/c++ clang-format
setting_prefix="{"
line1='"editor.formatOnType": true,'
line2='"editor.formatOnSave": true,'
line3='"C_Cpp.clang_format_fallbackStyle": "Google",'
line4='"C_Cpp.clang_format_style": "file",'
line5='"C_Cpp.clang_format_sortIncludes": true,'
line6='"C_Cpp.formatting": "Default",'
setting_postfix="}"

if [ ! -f "$whole_setting_path" ];then
    echo "new user setting"
    if [[ ! -d "$user_setting_path" ]]
    then
        echo "the user setting directory does not exist, building..."
        cmd="mkdir -p $user_setting_path"
        ${cmd}
    fi
    echo -e ${setting_prefix} >> ${whole_setting_path}
    echo -e ${line1} >> ${whole_setting_path}
    echo -e ${line2} >> ${whole_setting_path}
    echo -e ${line3} >> ${whole_setting_path}
    echo -e ${line4} >> ${whole_setting_path}
    echo -e ${line5} >> ${whole_setting_path}
    echo -e ${line6} >> ${whole_setting_path}
    echo -e ${setting_postfix} >> ${whole_setting_path}
else
    while read line
    do
        if [[ $line =~ '"C_Cpp.clang_format_fallbackStyle": "Google"' ]] ; then    
            echo "you already had a clang format configuration."
            echo "please check if the configuration file is what you want."
            return
        fi
    done < "$whole_setting_path";
    
    echo "add clang-format configuration into setting.json"
    sed -i "2i$line1" ${whole_setting_path}
    sed -i "3i$line2" ${whole_setting_path}
    sed -i "4i$line3" ${whole_setting_path}
    sed -i "5i$line4" ${whole_setting_path}
    sed -i "6i$line5" ${whole_setting_path}
    sed -i "7i$line6" ${whole_setting_path}
fi

echo "Done"

    
    
    