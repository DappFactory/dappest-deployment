# Cluster level metadata
apiVersion: kops/v1alpha2
kind: Cluster
metadata:
  name: ${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}
spec:
  api:
    loadBalancer:
      type: Public

  authorization:
    rbac: {}
  kubelet:
    anonymousAuth: false

  kubeAPIServer:
    authorizationRbacSuperUser: admin

  channel: stable

  cloudLabels:
    ManagedWith: KOPS
    KeepUntil: permanent
    Cluster: ${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}
    Stack: Kubernetes

  cloudProvider: aws

  configBase: s3://cluster.${HOSTED_ZONE}/${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}

  etcdClusters:
  # etcd needs a quorum of 3 hosts in a master group.
  - etcdMembers:
${ETCD_MEMBERS}
    name: main
  - etcdMembers:
${ETCD_MEMBERS}
    name: events

  iam:
    legacy: false

  kubernetesApiAccess:
  - 0.0.0.0/0

  kubernetesVersion: 1.9.6
  masterInternalName: api.internal.${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}
  masterPublicName: api.${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}

  networkID:  ${VPC_ID}
  networkCIDR: ${VPC_CIDR_BLOCK}

  networking:
    weave:
      mtu: 8912
  nonMasqueradeCIDR: 100.64.0.0/10
  sshAccess:
  - ${VPC_CIDR_BLOCK}

  subnets:
${PRIVATE_SUBNETS}${PUBLIC_SUBNETS}

  topology:
    dns:
      type: Public
    masters: private
    nodes: private

  additionalPolicies:
    node: |
      [
        {
          "Effect": "Allow",
          "Action": ["route53:ChangeResourceRecordSets"],
          "Resource": ["arn:aws:route53:::hostedzone/${HOSTED_ZONE_ID}"]
        },
        {
          "Effect": "Allow",
          "Action": ["route53:ListHostedZones",
                     "route53:ListResourceRecordSets"],
          "Resource": ["*"]
        },
        {
          "Effect": "Allow",
          "Action": ["logs:*"],
          "Resource": ["*"]
        }
      ]
    master: | # see if there's a practical way to restrict k8s to only killing k8s nodes...
      [
        {
          "Effect": "Allow",
          "Action": [
            "autoscaling:DescribeAutoScalingGroups",
            "autoscaling:DescribeAutoScalingInstances",
            "autoscaling:SetDesiredCapacity",
            "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
      ]

${MASTER_INSTANCE_GROUP}
---

apiVersion: kops/v1alpha2
kind: InstanceGroup
metadata:
  labels:
    kops.k8s.io/cluster: ${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}
  name: dappest-nodes
spec:
  image: kope.io/k8s-1.8-debian-jessie-amd64-hvm-ebs-2018-02-08
  machineType: t3.medium
  maxSize: 3
  minSize: 3
  nodeLabels:
    kops.k8s.io/instancegroup: dappest-node
  cloudLabels:
    k8s.io/cluster-autoscaler/enabled: ""
    kubernetes.io/cluster/${CLUSTER_NAME_PREFIX}.${HOSTED_ZONE}: owned
  role: Node
  subnets:
${PRIVATE_SUBNETS_LIST}
