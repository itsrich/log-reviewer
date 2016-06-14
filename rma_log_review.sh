#!/bin/bash

# Script Name : rma_log_review.sh
# Author      : Richard Presland
# Date        : 2016-06-13
# Version     : v0.1
# History
# V0.1 - draft

function iterate_greps
{   
    echo -e "script version : v1p10"  | tee -a "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"
    echo -e "start          : `date`" | tee -a "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"

    while read line;
    do 
        VAR=`grep -I -i -r -n -H -P "$line" "$path_to_diags"`
        
        if [[ -z "${VAR}" ]]; then 
                OUTPUT_NOHIT=$OUTPUT_NOHIT`echo -e "\nNO HIT: $line"`
                echo "$line"
            else 
                COUNT=0
                OUTPUT_HIT=$OUTPUT_HIT`echo -e "\n$line"`
                echo -e "\n$line"
                while read line2;
                do 
                    let COUNT=COUNT+1
                    if [ $COUNT -gt 100 ]; then
                        echo "# More than 100 hits... continuing with next grep string"
                        OUTPUT_HIT=$OUTPUT_HIT`echo "\n# More than 100 hits... continuing with next grep string"`
                        break
                    fi  
                    
                    hit=`echo "$line2" | cut -c $cut_length-`
                    echo -e "# ${hit:0:147}"
                    OUTPUT_HIT=$OUTPUT_HIT`echo "\n# $hit"`
                    

                done < <(echo "$VAR")
                echo -e "####\n"
                
                OUTPUT_HIT=$OUTPUT_HIT`echo -e "\n####\n"`


        fi                          
                        
    done < $path_to_script/05_GREPS_INFO/info.txt

    
    for j in {1..100}
    do  
        
        grep_file=`ls -1 $path_to_script/03_GREPS/ | cat -n | head -$j | tail -1 | cut --character=8-200`
        if [[ "$grep_file" == "z_DO_NOT_DELETE.txt" ]]; then
            echo -e " "
            echo -e "finish         : `date`\n" | tee -a "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"
            echo -e "#################################################################$OUTPUT_HIT\n#################################################################" >> "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"
            echo -e "$OUTPUT_NOHIT" >> "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"
            
            exit
        else 


            while read line;
            do 
                VAR=`grep -I -i -r -n -H -P "$line" "$path_to_diags"`
                
                if [[ -z "${VAR}" ]]; then 
                        OUTPUT_NOHIT=$OUTPUT_NOHIT`echo -e "\nNO HIT: $line"`
                        echo "NO HIT: $line"
                    else 
                        COUNT=0
                        OUTPUT_HIT=$OUTPUT_HIT`echo -e "\n#### HIT: $line"`
                        echo -e "\n#### HIT: $line"
                        while read line2;
                        do 
                            let COUNT=COUNT+1
                            if [ $COUNT -gt 100 ]; then
                                echo "# More than 100 hits... continuing with next grep string"
                                OUTPUT_HIT=$OUTPUT_HIT`echo "\n# More than 100 hits... continuing with next grep string"`
                                break
                            fi  
                            
                            hit=`echo "$line2" | cut -c $cut_length-`
                            echo -e "# ${hit:0:147}"
                            OUTPUT_HIT=$OUTPUT_HIT`echo "\n# $hit"`
                            

                        done < <(echo "$VAR")
                        echo -e "####\n"
                        
                        OUTPUT_HIT=$OUTPUT_HIT`echo -e "\n####\n"`


                fi                          
                                
            done < $path_to_script/03_GREPS/$grep_file
    
        fi
        
    done
    
        
}

function main
{
    if [[ -z "${path_to_diags}" ]]; then 
        echo -e "NO MORE DIAGS DRAGGED TO REVIEW - MAXIMUM OF NINE DIAGS FOLDERS CAN BE RUN SIMULTANEOUSLY AT ANY ONE TIME"
        exit
    fi
    
    index=`ls -1 "$path_to_output/" | tail -1 | cut --character=1-4`
    let index=index+1
    

    
    cut_path_to_diags="`basename "$path_to_diags"`"
    
    mkdir "$path_to_output/$index-$cut_path_to_diags"
    echo -e "\ndiags : $path_to_diags" | tee -a "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"
    echo -e "script: $path_to_script" | tee -a "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt"
    echo -e "output: $path_to_output/$index-$cut_path_to_diags\n" | tee -a "$path_to_output/$index-$cut_path_to_diags/$cut_path_to_diags-rma_log_review_output.txt" 
    iterate_greps

}

path_to_diags=`cygpath -au "$1"`
path_to_script=`cygpath -au "$(dirname "$0")"`
path_to_output="$path_to_script/02_SCRIPT_OUTPUT"
cut_length=`expr  ${#path_to_diags} + 2`
main
