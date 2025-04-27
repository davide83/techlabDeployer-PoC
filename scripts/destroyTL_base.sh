#!/bin/bash
##################################################
#              destroyTL_base.sh                 #
#                                                #
#       ARGs:                                    #
#           - $1 TL_ID                           #
#           - $2 TL_MEMBER_ID                    #
#           - $3 CONFIRM_TERMINATION_BOOL        #
##################################################

TL_ID=$1
TL_MEMBER_ID=$2
CONFIRM_TERMINATION_BOOL=$3

## Tests input parameters
TESTRESULT=0
# nb params
if [[ -z "$CONFIRM_TERMINATION_BOOL" || $CONFIRM_TERMINATION_BOOL = false ]] ; then
    echo "ERROR - 3rd argument - CONFIRM_TERMINATION_BOOL - must be <true>"
    TESTRESULT=1
    exit $TESTRESULT
fi

### Get PCI_PROJECT_ID (Col3) and VRACK_ID (Col7)
# from PSEUDO-DB where TL_ID and TL_MEMBER_ID match
## `.data/deployerTL-db.csv`
PCI_PROJECT_ID=$(awk -F';' \
    -v tlid="${TL_ID}" \
    -v tlmemid="member_${TL_MEMBER_ID}" \
    '($1 == tlid && $2 == tlmemid) {print $3}' \
    .data/deployerTL-db.csv)
echo "PCI_PROJECT_ID=$PCI_PROJECT_ID"
VRACK_ID=$(awk -F';' \
    -v tlid="${TL_ID}" \
    -v tlmemid="member_${TL_MEMBER_ID}" \
    '($1 == tlid && $2 == tlmemid) {print $7}' \
    .data/deployerTL-db.csv)
echo "VRACK_ID=$VRACK_ID"

### Deattach pci_project_id from vrack_id via API
# remove this publicCloud project from this vrack
## `utils/ovhAPI.sh DELETE /vrack/{serviceName}/cloudProject/{projectId}` returns `{}`
REMOVE_PCI_FROM_VRACK_RESPONSE=$(utils/ovhAPI.sh DELETE /vrack/$VRACK_ID/cloudProject/$PCI_PROJECT_ID | jq -r '.')
echo "REMOVE_PCI_FROM_VRACK_RESPONSE: $REMOVE_PCI_FROM_VRACK_RESPONSE"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%15+5)))

### TERMINATE vrack_id via API
# Ask for the termination of your service.
# Admin contact of this service will receive a termination token by email 
# in order to confirm its termination with /confirmTermination endpoint.
## `utils/ovhAPI.sh POST /vrack/{serviceName}/terminate` returns `string`
TERMINATE_VRACK_RESPONSE=$(utils/ovhAPI.sh POST /vrack/$VRACK_ID/terminate | jq -r '.')
echo "TERMINATE_VRACK_RESPONSE: $TERMINATE_VRACK_RESPONSE"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%20+10)))

### TERMINATE pci_project_id via API
# Ask for the termination of your service. 
# Admin contact of this service will receive a termination token by email 
# in order to confirm its termination with /confirmTermination endpoint.
## `utils/ovhAPI.sh POST /cloud/project/{serviceName}/terminate` returns `string`
TERMINATE_PCI_RESPONSE=$(utils/ovhAPI.sh POST /cloud/project/$PCI_PROJECT_ID/terminate | jq -r '.')
echo "TERMINATE_PCI_RESPONSE: $TERMINATE_PCI_RESPONSE"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
#sleep $(echo $(($RANDOM%20+10)))

### UPDATE PSEUDO-DB
#echo "techlab_id;member_id;pci_project_id;pci_order_id;pci_order_url;is_order_paid;vrack_id;tl_created_at;tl_terminated_at" > .data/deployerTL-db.csv
date_str=$(date -u)
awk -F';' -v tlid="${TL_ID}" -v tlmemid="member_${TL_MEMBER_ID}" -v td="${date_str}" \
        '($1 == tlid && $2 == tlmemid) { $9 = td } {print}' OFS=";" \
        .data/deployerTL-db.csv > .data/deployerTL-db.csv-updated
mv .data/deployerTL-db.csv .data/deployerTL-db.csv-old
mv .data/deployerTL-db.csv-updated .data/deployerTL-db.csv

### NOTIFY TERMINATION REQUEST
#echo ">>> TERMINATED! TechLab's ENVs for ${TL_ID}/member_${TL_MEMBER_ID} has successfully terminated!"

### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%30+10)))