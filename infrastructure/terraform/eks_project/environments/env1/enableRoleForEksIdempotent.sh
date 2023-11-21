
#rolename="AWSReservedSSO_AdministratorAccess-unrestricted_58c9bbf239970a34"
#accountId="363201544063"
#clustername="alf-dev-eks-auth0-eks"

if [[ -z "$rolename" ]]; then
    echo "Must provide rolename in environment" 1>&2
    exit 1
fi

if [[ -z "$accountId" ]]; then
    echo "Must provide accountId in environment" 1>&2
    exit 1
fi

if [[ -z "$clustername" ]]; then
    echo "Must provide clustername in environment" 1>&2
    exit 1
fi

# non existant role gives:
#  Error: no iamidentitymapping with arn "arn:aws:iam::363201544063:role/AWSReservedSSO_AdministratorAccess-unrestricted_58c9bbf239970a34" found
eksctl_search_role=$(eksctl get iamidentitymapping  --cluster $clustername 2>&1)
echo $eksctl_search_role


if [[ $eksctl_search_role == *"$rolename"* ]]; then
    echo "Found the role. Dont recreate"
else
    echo "Not found the role. Add the role now."
    eksctl create iamidentitymapping \
        --cluster $clustername \
        --arn "arn:aws:iam::$accountId:role/$rolename" \
        --username admin \
        --group system:masters
fi

