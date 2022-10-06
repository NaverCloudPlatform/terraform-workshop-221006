#!/bin/bash


ACCESSKEY=${access_key}				# access key id (from portal or Sub Account)
SECRETKEY=${secret_key}				# secret key (from portal or Sub Account)
TIMESTAMP=$(echo $(($(date +%s%N)/1000000)))
METHOD="POST"
URL="https://cloudloganalytics.apigw.ntruss.com"
URI="/api/v1/vpc/servers/collecting-infos"

nl=$'\\n'
SIG="$${METHOD}"' '"$${URI}"$${nl}
SIG+="$${TIMESTAMP}"$${nl}
SIG+="$${ACCESSKEY}"
SIGNATURE=$(echo -n -e "$${SIG}"|iconv -t utf8 |openssl dgst -sha256 -hmac $${SECRETKEY} -binary|openssl enc -base64)


get_payload() {
   cat << EOF
 {
  "collectingInfos": [
%{ for server_name, attrs in servers ~}
    {
        "logPath": "/var/log/messages",
        "logTemplate": "SYSLOG",
        "logType": "SYSLOG",
        "servername": "${server_name}",
        "osType": "CentOS 7",
        "ip": "${attrs.private_ip}",
        "instanceNo": ${attrs.server_id}
    },
    {
        "logPath": "/var/log/secure*",
        "logTemplate": "Security",
        "logType": "security_log",
        "servername": "${server_name}",
        "osType": "CentOS 7",
        "ip": "${attrs.private_ip}",
        "instanceNo": ${attrs.server_id}
    }%{ if attrs != element(values(servers), length(values(servers))-1) },%{ endif }
%{ endfor ~}
  ]
}
EOF
}

RES=$(curl -X $${METHOD} "$${URL}$${URI}" \
-H "accept: application/json" \
-H "x-ncp-region_code: KR" \
-H "x-ncp-region_no: 1" \
-H "Content-Type: application/json" \
-H "x-ncp-iam-access-key: $${ACCESSKEY}" \
-H "x-ncp-apigw-timestamp: $${TIMESTAMP}" \
-H "x-ncp-apigw-signature-v2: $${SIGNATURE}" \
-d "$(get_payload)")

yum install -y jq
CONFIGKEY=$(echo $RES | jq -r '.result')
ansible-playbook -i /root/playbooks/inventory.ini -e "configKey=$${CONFIGKEY}" /root/playbooks/install-cla-agent.yaml



