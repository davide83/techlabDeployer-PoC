TechLabs' DEPLOYER
===

A personal proof of concept _(PoC)_ as **BASH Shell** `scripts`.

# User case

As Tech Lab owner, _TL_OWNER_, is **A MUST TO HAVE** to `create` and `destroy` Tech Lab environments, _TL_ENVIRONMENT_, inside the current and active team's AccountID (nic-handle) instead of asking for generating commercial voucher about Public Cloud for Tech Lab members, _TL_MEMBERS_, and then be consumed by them.

## What a TL_ENVIRONMENT means?

A **TL_ENVIRONMENT** contains one or more `Service` & `Account` depending on its type, __TL_TYPE__, like the below table as non-exhaustive examples.

| TL_TYPE | ovh_Service | ovh_Account | notes |
| ----- | ----- | ----- | ----- |
| BASE | (Public Cloud Service _1_, vRack Service _1_) | Service only! | OS_USERNAME with ADMIN (administrator & ai_training_operator) roles |
| ADV | ({Public Cloud Service _1_, Public Cloud Service _n_}, vRack Service _1_) | Human vs Service | Account roles to be defined |
| EXPERT | n/a | n/a | EXPERT Service and Account to be defined |
| CUSTOM | n/a | n/a | TAILORED Service and Account to be defined |

> For the _PoC_ we are focusing on **BASE** as `TL_TYPE`

### PoC: scripts/ovhDeployerTL.sh
```bash
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
```

# Pre-requisites

> See [utils/README.md](utils/README.md) based on [_Starting Pack to manage your OVHcloud Services from shell_](https://github.com/ovh/public-cloud-examples/tree/main/configuration/shell)

# CREATE TL env

## Export TL env variables
```bash
export TL_DATE=20250508 # YYYYMMDD
export TL_OWNER=dletizia # login8
export TL_TYPE=BASE # base|BASE
export TL_MEMBERS=1 # MIN (1) | MAX (10) ?Soft-limit
export AUTOPAY_BOOL=false # true|false
```

### scripts/ovhDeployerTL.sh create
```bash
(techlab) dletizia@ovh techlabDeployer-PoC % scripts/deployerTL.sh create \
    $TL_DATE \
    $TL_OWNER \
    $TL_TYPE \
    $TL_MEMBERS \
    $AUTOPAY_BOOL
```

### BASE

Ordering a Public Cloud project from OVH API will include a vRack Service attached too! 
[ref. KB0050987](https://help.ovhcloud.com/csm/en-public-cloud-compute-order-instance-api?id=kb_article_view&sysparm_article=KB0050987)

> `time scripts/ovhDeployerTL.sh create 20250425 dletizia BASE 1 true`

```bash
(techlab) dletizia@ovh techlabDeployer-PoC % time scripts/ovhDeployerTL.sh create 20250425 dletizia BASE 1 true
BASE Service ordering for the TL_ID: 20250425-dletizia-BASE-1 ...
CART_ID=***
ITEM_ID=***
CONFIGURATION_ID=***
CART_ITEM +cloud for member 1
Cart's assign response: null (<null> means OK)
CHECKOUT_ORDER_URL=https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=***&orderPassword=***
i:0 ***
i:1 ***
i:2 ***
PCI_PROJECT_ID: ***
VRACK_ID: ***
PCI_MEMBER_USERNAME: ***
PCI_MEMBER_PASSWORD: ***
>> DONE +cloud,+vrack,+username for member 1
>>> DONE!
See .data/deployerTL-db.csv file for getting TechLab's (20250425-dletizia-BASE-1) order number (BC) url!

scripts/ovhDeployerTL.sh create 20250425 dletizia BASE 1 true  1.14s user 0.59s system 0% cpu 4:34.07 total
```

> `time scripts/ovhDeployerTL.sh create 20250425 dletizia BASE 2 false`

```bash
(techlab) dletizia@ovh techlabDeployer-PoC % time scripts/ovhDeployerTL.sh create 20250425 dletizia BASE 2 false
BASE Service ordering for the TL_ID: 20250425-dletizia-BASE-2 ...
CART_ID=***
ITEM_ID=***
CONFIGURATION_ID=***
CART_ITEM +cloud for member 1
Cart's assign response: null (<null> means OK)
CHECKOUT_ORDER_URL=https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=***&orderPassword=***
PCI_PROJECT_ID: pci-*001
VRACK_ID: pn-*001
PCI_MEMBER_USERNAME: null
PCI_MEMBER_PASSWORD: null
>> DONE +cloud,+vrack,+username for member 1
CART_ID=***
ITEM_ID=***
CONFIGURATION_ID=***
CART_ITEM +cloud for member 2
Cart's assign response: null (<null> means OK)
CHECKOUT_ORDER_URL=https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=***&orderPassword=***
PCI_PROJECT_ID: pci-*002
VRACK_ID: pn-*002
PCI_MEMBER_USERNAME: null
PCI_MEMBER_PASSWORD: null
>> DONE +cloud,+vrack,+username for member 2
>>> DONE!
See .data/deployerTL-db.csv file for getting TechLab's (20250425-dletizia-BASE-2) order number (BC) url!

scripts/ovhDeployerTL.sh create 20250425 dletizia BASE 2 false  1.39s user 0.72s system 0% cpu 9:57.28 total
```

> `time scripts/ovhDeployerTL.sh create 20250426 dletizia BASE 2 true`

```bash
(techlab) dletizia@ovh techlabDeployer-PoC % scripts/ovhDeployerTL.sh create 20250426 dletizia
 BASE 2 true
BASE Service ordering for TL_ID: 20250426-dletizia-BASE-2 ...
CART_ID=***
ITEM_ID=***
CONFIGURATION_ID=***
CART_ITEM +cloud for member 1
Cart's assign response: null (<null> means OK)
CHECKOUT_ORDER_URL=https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=***&orderPassword=***
i:0 ***
i:1 ***
i:2 ***
PCI_PROJECT_ID: ***
vRack's alter objects: null (<null> means OK)
VRACK_ID: ***
PCI_MEMBER_USERNAME: ***
PCI_MEMBER_PASSWORD: ***
>> DONE +cloud,+vrack,+username for member 1
CART_ID=***
ITEM_ID=***
CONFIGURATION_ID=***
CART_ITEM +cloud for member 2
Cart's assign response: null (<null> means OK)
CHECKOUT_ORDER_URL=https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=***&orderPassword=***
i:0 ***
i:1 ***
i:2 ***
PCI_PROJECT_ID: ***
vRack's alter objects: null (<null> means OK)
VRACK_ID: ***
PCI_MEMBER_USERNAME: ***
PCI_MEMBER_PASSWORD: ***
>> ORDERED +cloud,+vrack,+username for member 2
>>> DONE!
See .data/deployerTL-db.csv file for getting TechLab's (20250426-dletizia-BASE-2) order number (BC) url!
```

#### Service Account

> **Service Account** `.data/deployerTL-db.csv` _CREATED BY `scripts/ovhDeployerTL.sh create` Action_

- Create Service Account, `OS Username & Password`, and assign it to __TL_MEMBER__
```json
{
  "description": "TechLab Member's Admin user",
  "role": "admin",
  "roles": [
    "administrator",
     "ai_training_operator"
  ]
}
```
[OVH API](https://eu.api.ovh.com/console/?section=%2Fcloud&branch=v1#post-/cloud/project/-serviceName-/user)

##### PSEUDO-DB

**PSEUDO-DB** `.data/deployerTL-db.csv` _POPULATED BY `scripts/ovhDeployerTL.sh create` Action_

| techlab_id | member_id | pci_project_id | pci_order_id | pci_order_url | is_order_paid | vrack_id | tl_created_at | tl_terminated_at | pci_member_username | pci_member_password |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| 20250425-dletizia-BASE-1 | member_1 | a29f5c9d4b914cda9a74b03e9094f208 | 226917728 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226917728&orderPassword=4sRmcA8Rao | true | pn-1228051 | Fri Apr 25 04:53:00 UTC 2025 | null | null | null |
| 20250425-dletizia-BASE-2 | member_1 | pci-*001 | 226926618 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226926618&orderPassword=jDmj7bStPm | false | pn-*001 | Fri Apr 25 14:48:05 UTC 2025 | null | null | null |
| 20250425-dletizia-BASE-2 | member_2 | pci-*002 | 226926717 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226926717&orderPassword=CH4PaqCsUc | false | pn-*002 | Fri Apr 25 14:52:17 UTC 2025 | null | null | null |
| 20250426-dletizia-BASE-2 | member_1 | f62fd318294d4ea4a07059b7cdca30eb | 226944154 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226944154&orderPassword=hcsTYDDUtL | true | pn-1228351 | Sat Apr 26 22:05:28 UTC 2025 | Sun Apr 27 00:41:04 UTC 2025 | null | null |
| 20250426-dletizia-BASE-2 | member_2 | 8e7a4319ef424c5386b3ef7b4dee7671 | 226944184 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226944184&orderPassword=CwZ1RdPJin | true | pn-1228353 | Sat Apr 26 22:09:18 UTC 2025| Sun Apr 27 00:42:12 UTC 2025 | null | null |

# DESTROY TL env

## BASE

1. **DELETE** `pci_project_id` from `vrack_id` via _API_
    1. [OVH API](https://eu.api.ovh.com/console/?section=%2Fvrack&branch=v1#delete-/vrack/-serviceName-/cloudProject/-project-)
2. **TERMINATE** `vrack_id` via _API_
    1. [OVH API](https://eu.api.ovh.com/console/?section=%2Fvrack&branch=v1#post-/vrack/-serviceName-/terminate)
    2. REQUIRE "manual" action on DELETE via email (token) confirmation (Admin contact of this service will receive a termination token by email in order to confirm its termination with /confirmTermination endpoint)
3. **confirmTermination** `vrack_id` via _EMAIL/MANUAL_
    1. `{
        "commentary": "TechLabs' TEMPORARY Environments",
        "futureUse": "NOT_REPLACING_SERVICE",
        "reason": "NOT_NEEDED_ANYMORE",
        "token": "<token-sent-by-email-to-admin-contact>"
    }`
    2. [OVH API](https://eu.api.ovh.com/console/?section=%2Fvrack&branch=v1#post-/vrack/-serviceName-/confirmTermination)
4. **TERMINATE** `pci_project_id` via _API_
    1. [OVH API](https://eu.api.ovh.com/console/?section=%2Fcloud&branch=v1#post-/cloud/project/-serviceName-/terminate)
    2. REQUIRE "manual" action on DELETE via email (token) confirmation (Admin contact of this service will receive a termination token by email in order to confirm its termination with /confirmTermination endpoint)
5. **confirmTermination** `pci_project_id` via _EMAIL/MANUAL_
    1. `{
        "commentary": "TechLabs' TEMPORARY Environments",
        "futureUse": "NOT_REPLACING_SERVICE",
        "reason": "NOT_NEEDED_ANYMORE",
        "token": "<token-sent-by-email-to-admin-contact>"
    }`
    2. [OVH API](https://eu.api.ovh.com/console/?section=%2Fcloud&branch=v1#post-/cloud/project/-serviceName-/confirmTermination)

> _NB_ **confirmTermination** still a `manual` procedure yet!

### Export TL env variables
```bash
export TL_ID="$TL_DATE-$TL_OWNER-$TL_TYPE-$TL_MEMBERS"
export CONFIRM_TERMINATION_BOOL=true
```

### scripts/ovhDeployerTL.sh destroy

> `scripts/ovhDeployerTL.sh destroy 20250425-dletizia-BASE-1 true`

```bash
(techlab) dletizia@ovh techlabDeployer-PoC % scripts/ovhDeployerTL.sh destroy 20250425-dletizia-BASE-1 true
BASE Service terminating for TL_ID: 20250425-dletizia-BASE-1 ...
PCI_PROJECT_ID=a29f5c9d4b914cda9a74b03e9094f208
VRACK_ID=pn-1228051
REMOVE_PCI_FROM_VRACK_RESPONSE: {
  "lastUpdate": "2025-04-26T23:11:29+02:00",
  "todoDate": "2025-04-26T23:11:29+02:00",
  "id": 5955813,
  "status": "init",
  "serviceName": "pn-1228051",
  "orderId": null,
  "targetDomain": "a29f5c9d4b914cda9a74b03e9094f208",
  "function": "removeCloudTenantLink"
}
TERMINATE_VRACK_RESPONSE: An email was sent in order to acknowledge your request.
TERMINATE_PCI_RESPONSE: An email was sent in order to acknowledge your request.
>> TERMINATED -cloud,-vrack for member 1
>>> DONE! TechLab's 20250425-dletizia-BASE-1 terminated!

\!/ MANUAL confirmation Action(s) is(are) needed from you to finalize it(them) \!/
```

> `scripts/ovhDeployerTL.sh destroy 20250426-dletizia-BASE-2 true`

```bash
(techlab) dletizia@ovh techlabDeployer-PoC % scripts/ovhDeployerTL.sh destroy 20250426-dletizia-BASE-2 true
BASE Service terminating for TL_ID: 20250426-dletizia-BASE-2 ...
PCI_PROJECT_ID=f62fd318294d4ea4a07059b7cdca30eb
VRACK_ID=pn-1228351
REMOVE_PCI_FROM_VRACK_RESPONSE: {
  "targetDomain": "f62fd318294d4ea4a07059b7cdca30eb",
  "function": "removeCloudTenantLink",
  "todoDate": "2025-04-27T02:40:19+02:00",
  "serviceName": "pn-1228351",
  "orderId": null,
  "status": "init",
  "id": 5956151,
  "lastUpdate": "2025-04-27T02:40:19+02:00"
}
TERMINATE_VRACK_RESPONSE: An email was sent in order to acknowledge your request.
TERMINATE_PCI_RESPONSE: An email was sent in order to acknowledge your request.
>> TERMINATED -cloud,-vrack for member 1
PCI_PROJECT_ID=8e7a4319ef424c5386b3ef7b4dee7671
VRACK_ID=pn-1228353
REMOVE_PCI_FROM_VRACK_RESPONSE: {
  "status": "init",
  "id": 5956152,
  "serviceName": "pn-1228353",
  "lastUpdate": "2025-04-27T02:41:44+02:00",
  "orderId": null,
  "function": "removeCloudTenantLink",
  "targetDomain": "8e7a4319ef424c5386b3ef7b4dee7671",
  "todoDate": "2025-04-27T02:41:44+02:00"
}
TERMINATE_VRACK_RESPONSE: An email was sent in order to acknowledge your request.
TERMINATE_PCI_RESPONSE: An email was sent in order to acknowledge your request.
>> TERMINATED -cloud,-vrack for member 2
>>> DONE! TechLab's 20250426-dletizia-BASE-2 terminated!

\!/ MANUAL confirmation Action(s) is(are) needed from you to finalize it(them) \!/
```

#### PSEUDO-DB

**PSEUDO-DB** `.data/deployerTL-db.csv` _UPDATED BY `scripts/ovhDeployerTL.sh destroy` Action_

| techlab_id | member_id | pci_project_id | pci_order_id | pci_order_url | is_order_paid | vrack_id | tl_created_at | tl_terminated_at | pci_member_username | pci_member_password |
| ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- |
| 20250425-dletizia-BASE-1 | member_1 | a29f5c9d4b914cda9a74b03e9094f208 | 226917728 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226917728&orderPassword=4sRmcA8Rao | true | pn-1228051 | Fri Apr 25 04:53:00 UTC 2025 | Sat Apr 26 21:12:02 UTC 2025 | null | null |
| 20250425-dletizia-BASE-2 | member_1 | pci-*001 | 226926618 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226926618&orderPassword=jDmj7bStPm | false | pn-*001 | Fri Apr 25 14:48:05 UTC 2025 | null | null | null |
| 20250425-dletizia-BASE-2 | member_2 | pci-*002 | 226926717 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226926717&orderPassword=CH4PaqCsUc | false | pn-*002 | Fri Apr 25 14:52:17 UTC 2025 | null | null | null |
| 20250426-dletizia-BASE-2 | member_1 | f62fd318294d4ea4a07059b7cdca30eb | 226944154 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226944154&orderPassword=hcsTYDDUtL | true | pn-1228351 | Sat Apr 26 22:05:28 UTC 2025 | Sun Apr 27 00:41:04 UTC 2025 | null | null |
| 20250426-dletizia-BASE-2 | member_2 | 8e7a4319ef424c5386b3ef7b4dee7671 | 226944184 | https://www.ovh.com/cgi-bin/order/display-order.cgi?orderId=226944184&orderPassword=CwZ1RdPJin | true | pn-1228353 | Sat Apr 26 22:09:18 UTC 2025| Sun Apr 27 00:42:12 UTC 2025 | null | null |

# Q&A

- Feedback
- Next Steps

# Thank you!

Grazie

d