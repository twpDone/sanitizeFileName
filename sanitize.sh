DONOTRM=0
DEBUG=0
RECURSE=0
START=0

usage(){
    
    echo "Usage: ""$0""[-dtR] start"
    echo ""
    echo $0" Rename all badly named files and directories at your current position"
    echo ""
    echo "Options :"
    echo "    -d : Debug Mode, more Verbose"
    echo "    -t : Test Mode, do not remove original files"
    echo "    -R : Enable Recursion in subdirectories. /!\ Warning this could break things, test before"
    echo "    -h : Help, Print this message"
    echo ""
    echo "    start : Start the program, protect you from accidental run of this command" 
    echo ""
    echo ""
    exit 3
}

for arg in "$@"
do
    case $arg in
        "-d")
            DEBUG=1
            ;;  
        "-t")
            DONOTRM=1
            ;;  
        "-R")
            RECURSE=1
            ;;
        "-h")
            usage
            ;;
        "start")
            START=1
            ;;
        *)
            ;;
    esac
done

if test "$START" -ne 1
then
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ""
    echo "You must specify 'start' as an argument of this command"
    echo ""
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ""
    usage
fi

message(){
    indent=""
    indentLevel=$1
    mtext=$2

    if test $indentLevel -lt 0
    then
        indentLevel=0
    fi
    if test $indentLevel -gt 0
    then
        for space in `seq 1 $indentLevel`
        do
            indent=$indent" "
        done
    fi
    echo $indent$mtext
}

fail(){
    message 0 "[-] ""$1"
}

success(){
    message 0 "[+] ""$1"
}

action(){
    message 0 "[*] ""$1"
}

skip(){
    message 0 "[/] ""$1"
}

debug(){
    message 0 "[D] ""$1"
}

recurmessage(){
    message 0 "[R] ""$1"
}

process(){

    if test "$DEBUG" -eq 1
    then
        debug "DEBUG : ""$DEBUG"
        debug "DONOTRM / TESTMODE : ""$DONOTRM"
        debug "RECURSE : ""$RECURSE"
    fi

    for fic in `ls | tr " " "|"`
    do
        echo ""

        originalFic=`echo $fic | tr "|" " "`
        newname=`echo "$fic" | sed y/":\?=, |"/"--____"/ | sed s/"%2F"/"_"/g`


        if test "$DEBUG" -eq 1
        then
            debug "originalFile : ""$originalFic"
            debug "newname : ""$newname"
        fi


        if test -e "$originalFic"
        then
            echo "Orginal : "$originalFic
            if test "$originalFic" != "$newname"
            then
                action "Trying cp "
                cp -R "$originalFic" "$newname"

                if test -e "$newname"
                then
                    echo "cp ""$originalFic""--->""$newname"
                    if test "$DONOTRM" -ne 1
                    then
                        action "rm ""$originalFic"
                        rm -Rf "$originalFic"
                    else
                        skip "$originalFic"" Have not been removed"
                    fi
                else
                    fail "Copy Failed : ""$originalFic""--->""$newname"
                fi

        if test "$DEBUG" -eq 1
        then
            debug "originalFile : ""$originalFic"
            debug "newname : ""$newname"
        fi


        if test -e "$originalFic"
        then
            echo "Orginal : "$originalFic
            if test "$originalFic" != "$newname"
            then
                action "Trying cp "
                cp -R "$originalFic" "$newname"

                if test -e "$newname"
                then
                    echo "cp ""$originalFic""--->""$newname"
                    if test "$DONOTRM" -ne 1
                    then
                        action "rm ""$originalFic"
                        rm -Rf "$originalFic"
                    else
                        skip "$originalFic"" Have not been removed"
                    fi
                else
                    fail "Copy Failed : ""$originalFic""--->""$newname"
                fi
            else
                success "No renaming is necesary"
            fi
        else
            fail "Fichier introuvable : ""$originalFic"
        fi

        if test "$RECURSE" -eq 1
        then
            if test -d "$newname"
            then
                recurmessage "cd to [""$newname""] from [""$PWD""]"
                cd "$newname"
                process
                cd ..
                recurmessage "cd back to [""$PWD""] from [""$newname""]"
            fi
        fi
    done
}
process
exit 1                                                                                               167,6         Bot
