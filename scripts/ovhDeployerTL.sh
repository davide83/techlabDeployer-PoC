#!/bin/bash
#############################################
#               ovhDeployerTL.sh            #
#############################################
#     Input parameters                      #
# (1) ACTION - required                     #
#     One of this: [create|destroy]         #
#############################################
# Examples:
# $ ./ovhDeployerTL.sh create \
#       TL_DATE=<YYYYMMDD> \
#       TL_OWNER=<login8> \
#       TL_TYPE=<base|BASE> \
#       TL_MEMBERS=<TL_MEMBERS_MIN=1|TL_MEMBERS_MAX=10> \
#       AUTOPAY_BOOL=<true|false>
#       
# $ ./ovhDeployerTL.sh destroy \
#       TL_ID=<TL_DATE-TL_OWNER-TL_TYPE-TL_MEMBERS> \
#       CONFIRM_TERMINATION_BOOL=<true|false>
#

### STORE TO PSEUDO DB - Init
if [[ ! -e .data/deployerTL-db.csv ]]; then
        mkdir -p .data
        echo "techlab_id;member_id;pci_project_id;pci_order_url;is_order_paid;vrack_id;tl_created_at;tl_terminated_at;pci_member_username;pci_member_password" > .data/deployerTL-db.csv
fi

# Script variables(s)
SCRIPTROOTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#source $SCRIPTROOTDIR/../ovhrc

# Input parameters
ACTION="${1}"

## Tests input parameters
TESTRESULT=0
# nb params
if [ $# -lt 1 -o $# -gt 6 ]
then
        echo "ERROR - Incorrect number of input parameters - Must be one Action [create|destroy] + 0..5 (min..max) params"
        TESTRESULT=1
        exit $TESTRESULT
fi
# ACTION
case $ACTION in
        create) TESTRESULT=0
        ## TL params CONFIG
        TL_DATE="${2}" # YYYYMMDD
        TL_OWNER="${3}" # login8
        TL_TYPE="${4}" # base|BASE
        TL_MEMBERS="${5}" # MIN (1) | MAX (10) ?!?Soft-limit and MANUAL SERVICE TERMINATION
        AUTOPAY_BOOL="${6}" # false|true
        ### Generate TechLab's ID
        TL_ID="$TL_DATE-$TL_OWNER-$TL_TYPE-$TL_MEMBERS"
        #
        case $TL_TYPE in
                base|BASE) echo "BASE Service ordering for TL_ID: $TL_ID ..."
                for ((i=1;i<=TL_MEMBERS;i++)); do
                        #scripts/createCart_vrack.sh $TL_ID $TL_MEMBERS
                        #echo "CART CHECKOUT +vrack for member $i"              
                        scripts/createTL_base.sh $TL_ID $i $AUTOPAY_BOOL
                        echo ">> ORDERED +cloud,+vrack,+username for member $i"
                        ### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
                        if [ $i -eq 3 ]
                        then
                                sleep 60
                        fi
                        if [ $i -eq 6 ]
                        then
                                sleep 120
                        fi
                        if [ $i -eq 9 ]
                        then
                                sleep 180
                        fi
                        if [ $i -eq 12 ]
                        then
                                sleep 240
                        fi
                        if [ $i -eq 15 ]
                        then
                                sleep 300
                        fi
                        if [ $i -eq 18 ]
                        then
                                sleep 360
                        fi
                done
                echo ">>> DONE!"
                echo "See .data/deployerTL-db.csv file for getting TechLab's ($TL_ID) order number (BC) url!"
                exit $TESTRESULT;;
                *) echo "WARNING - Input TL_TYPE not allowed - Must be [base|BASE]"
                TESTRESULT=3
                exit $TESTRESULT;;
        esac;;
        destroy) TESTRESULT=0
        ## TL params CONFIG
        TL_ID="${2}" # TL_ID="$TL_DATE-$TL_OWNER-$TL_TYPE-$TL_MEMBERS"
        CONFIRM_TERMINATION_BOOL="${3}" # false|true
        #
        # Extract TL_TYPE and TL_MEMBERS from TL_ID
        TL_TYPE=$(echo $TL_ID | awk -F'-' '{ print $3}') # base|BASE
        #echo "$TL_TYPE"
        TL_MEMBERS=$(echo $TL_ID | awk -F'-' '{ print $4}') # MIN (1) | MAX (10) ?!?Soft-limit and MANUAL SERVICE TERMINATION
        #echo "$TL_MEMBERS"
        #
        case $TL_TYPE in
                base|BASE) echo "BASE Service terminating for TL_ID: $TL_ID ..."
                for ((i=1;i<=TL_MEMBERS;i++)); do             
                        scripts/destroyTL_base.sh $TL_ID $i $CONFIRM_TERMINATION_BOOL
                        echo ">> TERMINATED -cloud,-vrack,-username for member $i"
                        ### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
                        if [ $i -eq 3 ]
                        then
                                sleep 60
                        fi
                        if [ $i -eq 6 ]
                        then
                                sleep 120
                        fi
                        if [ $i -eq 9 ]
                        then
                                sleep 180
                        fi
                        if [ $i -eq 12 ]
                        then
                                sleep 240
                        fi
                        if [ $i -eq 15 ]
                        then
                                sleep 300
                        fi
                        if [ $i -eq 18 ]
                        then
                                sleep 360
                        fi
                done
                echo ">>> DONE! TechLab's $TL_ID terminated!"
                echo "\!/ MANUAL confirmation Action(s) is(are) needed from you to finalize it(them) \!/"
                exit $TESTRESULT;;
                *) echo "WARNING - Input TL_TYPE not allowed - Must be [base|BASE]"
                TESTRESULT=4
                exit $TESTRESULT;;
        esac;;
        *) echo "ERROR - Input Action not allowed - Must be in [create|destroy]"
        TESTRESULT=2
        exit $TESTRESULT;;
esac
