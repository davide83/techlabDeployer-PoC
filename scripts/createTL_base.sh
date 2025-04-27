#!/bin/bash
##################################################
#               createTL_base.sh                 #
#                                                #
#       ARGs:                                    #
#           - $1 TL_ID                           #
#           - $2 TL_MEMBER_ID                    #
#           - $3 AUTOPAY_BOOL                    #
##################################################

TL_ID=$1
TL_MEMBER_ID=$2
AUTOPAY_BOOL=$3

### Create Cart's
#
## `utils/ovhAPI.sh POST /order/cart JSON_BODY` returns `cartId`
JSON_STRING="{
\"ovhSubsidiary\":\"FR\",
\"description\":\"${TL_ID} ENVs\"
}"
#echo "$JSON_STRING"
CART_ID=$(utils/ovhAPI.sh POST /order/cart "$JSON_STRING" | jq -r '.cartId')
echo "CART_ID=$CART_ID"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%5+1)))

### Add Cart's Item (Cloud)
#
## `utils/ovhAPI.sh POST /order/cart/$CART_ID/cloud JSON_BODY` returns `itemId`
JSON_STRING="{
\"duration\":\"P1M\",
\"planCode\":\"project.2018\",
\"pricingMode\":\"default\",
\"quantity\":1
}"
#echo "$JSON_STRING"
ITEM_ID=$(utils/ovhAPI.sh POST /order/cart/$CART_ID/cloud "$JSON_STRING" | jq -r '.itemId')
echo "ITEM_ID=$ITEM_ID"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%10+5)))

### Configure Cart's Item
#
## `utils/ovhAPI.sh POST /order/cart/$CART_ID/item/$ITEM_ID/configuration JSON_BODY` returns `configurationId`
JSON_STRING="{
\"label\":\"description\",
\"value\":\"TMP_TL-${TL_ID}-member${TL_MEMBER_ID}\"
}"
#echo "$JSON_STRING"
CONFIGURATION_ID=$(utils/ovhAPI.sh POST /order/cart/$CART_ID/item/$ITEM_ID/configuration "$JSON_STRING" | jq -r '.id')
echo "CONFIGURATION_ID=$CONFIGURATION_ID"
echo "CART_ITEM +cloud for member $TL_MEMBER_ID"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%5+1)))

### Assign cartId to the authenticated Account
#
## `utils/ovhAPI.sh POST /order/cart/$CART_ID/assign` returns `null` if OK
CART_ASSIGN_RESPONSE=$(utils/ovhAPI.sh POST /order/cart/$CART_ID/assign)
echo "Cart's assign response: $CART_ASSIGN_RESPONSE (<null> means OK)"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%10+5)))

### Cart's checkout
#
## `utils/ovhAPI.sh POST /order/cart/$CART_ID/checkout JSON_OBJ` returns `url` & `orderId`
JSON_STRING="{
\"autoPayWithPreferredPaymentMethod\":$AUTOPAY_BOOL,
\"waiveRetractationPeriod\":false
}"
#echo "$JSON_STRING"
CHECKOUT_JSON=$(utils/ovhAPI.sh POST /order/cart/$CART_ID/checkout "$JSON_STRING" | jq -r '.')
CHECKOUT_ORDER_URL=$(echo "$CHECKOUT_JSON" | jq -r '.url')
CHECKOUT_ORDER_ID=$(echo "$CHECKOUT_JSON" | jq -r '.orderId')
echo "CHECKOUT_ORDER_URL=$CHECKOUT_ORDER_URL"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%90+45)))

### GET pci_project_id from paid order (BC)
#
## `utils/ovhAPI.sh GET /me/order/{orderId}/details` returns `[]`
ORDER_DETAILS=$(utils/ovhAPI.sh GET /me/order/$CHECKOUT_ORDER_ID/details | jq -r '.[]')
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%15+5)))
SAVEIFS=$IFS   # Save current IFS (Internal Field Separator).
IFS=$'\n'      # Change IFS (Internal Field Separator) to the newline char.
# Split a long string into a bash "indexed array" (via the parenthesis),
# separating by IFS (newline chars); notice that you must intentionally NOT use
# quotes around the parenthesis and variable here for this to work!
ORDER_DETAILS_ARRAY=($ORDER_DETAILS) 
IFS=$SAVEIFS   # Restore IFS
#echo "ORDER_DETAILS_ARRAY: ${ORDER_DETAILS_ARRAY[*]}"
ORDER_DETAILS_ARRAY_SIZE=${#ORDER_DETAILS_ARRAY[@]}
#echo "ORDER_DETAILS_ARRAY_SIZE: $ORDER_DETAILS_ARRAY_SIZE"
PCI_PROJECT_ID=""
if "$AUTOPAY_BOOL" ; then
    for ((i=0;i<ORDER_DETAILS_ARRAY_SIZE;i++)); do
        #
        ## `utils/ovhAPI.sh GET /me/order/{orderId}/details/{orderDetailId}` returns `{}`
        echo "i:$i ${ORDER_DETAILS_ARRAY[$i]}"
        ORDER_DETAIL_ID_JSON=$(utils/ovhAPI.sh GET /me/order/$CHECKOUT_ORDER_ID/details/${ORDER_DETAILS_ARRAY[$i]} | jq -r '.')    
        ORDER_DETAIL_TYPE=$(echo $ORDER_DETAIL_ID_JSON | jq -r '.detailType')
        if [ "$ORDER_DETAIL_TYPE" = "DURATION" ] ; then
            ORDER_PROJECT_ID=$(echo $ORDER_DETAIL_ID_JSON | jq -r '.domain')
            PCI_PROJECT_ID="$ORDER_PROJECT_ID"
            #echo "PCI_PROJECT_ID: $PCI_PROJECT_ID"
        fi
        ### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
        sleep $(echo $(($RANDOM%5+1)))
    done
else
    PCI_PROJECT_ID="pci-*00$TL_MEMBER_ID"
fi
echo "PCI_PROJECT_ID: $PCI_PROJECT_ID"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%180+120))) # wait more for vrack service availability :-)

### GET vrack_id from pci_project_id (PCI)
#
## `utils/ovhAPI.sh GET /cloud/project/{serviceName}/vrack` returns {}`
VRACK_ID=""
if "$AUTOPAY_BOOL" ; then
    #echo ""
    VRACK_ID=$(utils/ovhAPI.sh GET /cloud/project/$PCI_PROJECT_ID/vrack | jq -r '.id')
    #echo "VRACK_ID: $VRACK_ID"
    ### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
    sleep $(echo $(($RANDOM%10+5)))
    ### PUT vrack_id
    # Alter vrack_id object properties
    ## `utils/ovhAPI.sh PUT /vrack/{serviceName}` returns `null` if OK
    JSON_STRING="{
    \"description\":\"TMP_TL-${TL_ID}-member${TL_MEMBER_ID}\",
    \"name\":\"TMP_TL-${TL_ID}-member${TL_MEMBER_ID}\"
    }"
    #echo "$JSON_STRING"
    VRACK_ALTER_OBJS_RESPONSE=$(utils/ovhAPI.sh PUT /vrack/$VRACK_ID "$JSON_STRING")
    echo "vRack's alter objects: $VRACK_ALTER_OBJS_RESPONSE (<null> means OK)"
else
    VRACK_ID="pn-*00$TL_MEMBER_ID"
fi
echo "VRACK_ID: $VRACK_ID"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%15+5)))

### Create PCI_MEMBER_USERNAME & PCI_MEMBER_PASSWORD for TL_MEMBER_ID on PCI_PROJECT_ID (PCI)
#  Create user
## `utils/ovhAPI.sh POST /cloud/project/{serviceName}/user` returns {}`
PCI_MEMBER_USERNAME=""
PCI_MEMBER_PASSWORD=""
if "$AUTOPAY_BOOL" ; then
    JSON_STRING="{
    \"description\":\"TechLab ${TL_ID} member${TL_MEMBER_ID} Admin User\",
    \"role\":\"administrator\",
    \"roles\":[\"administrator\",\"ai_training_operator\"]
    }"
    #echo "$JSON_STRING"
    PCI_CREATE_USER_RESPONSE=$(utils/ovhAPI.sh POST /cloud/project/$PCI_PROJECT_ID/user "$JSON_STRING")
    #echo "PCI_CREATE_USER_RESPONSE: $PCI_CREATE_USER_RESPONSE"
    PCI_MEMBER_USERNAME=$(echo $PCI_CREATE_USER_RESPONSE | jq -r '.username')
    PCI_MEMBER_PASSWORD=$(echo $PCI_CREATE_USER_RESPONSE | jq -r '.password')
    #echo "PCI_MEMBER_PASSWORD: $PCI_MEMBER_PASSWORD"
else
    PCI_MEMBER_USERNAME="null"
    PCI_MEMBER_PASSWORD="null"
fi
echo "PCI_MEMBER_USERNAME: $PCI_MEMBER_USERNAME"
echo "PCI_MEMBER_PASSWORD: $PCI_MEMBER_PASSWORD"
### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
sleep $(echo $(($RANDOM%5+1)))

### STORE TO PSEUDO DB
#echo "techlab_id;member_id;pci_project_id;pci_order_id;pci_order_url;is_order_paid;vrack_id;tl_created_at;tl_terminated_at;pci_member_username;pci_member_password" > .data/deployerTL-db.csv
echo "$TL_ID;member_$TL_MEMBER_ID;$PCI_PROJECT_ID;$CHECKOUT_ORDER_ID;$CHECKOUT_ORDER_URL;$AUTOPAY_BOOL;$VRACK_ID;$(date -u);null;$PCI_MEMBER_USERNAME;$PCI_MEMBER_PASSWORD" >> .data/deployerTL-db.csv

### PREVENT API RATE-LIMIT OR RESOURCE AVAILABILITY
#sleep $(echo $(($RANDOM%30+10)))