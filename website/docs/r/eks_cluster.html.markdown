---
subcategory: "Tencent Kubernetes Engine(TKE)"
layout: "tencentcloud"
page_title: "TencentCloud: tencentcloud_eks_cluster"
sidebar_current: "docs-tencentcloud-resource-eks_cluster"
description: |-
  Provides an elastic kubernetes cluster resource.
---

# tencentcloud_eks_cluster

Provides an elastic kubernetes cluster resource.

## Example Usage

```hcl
resource "tencentcloud_vpc" "vpc" {
  name       = "tf-eks-vpc"
  cidr_block = "10.2.0.0/16"
}

resource "tencentcloud_subnet" "sub" {
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = "tf-as-subnet"
  cidr_block        = "10.2.11.0/24"
  availability_zone = "ap-guangzhou-3"
}
resource "tencentcloud_subnet" "sub2" {
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = "tf-as-subnet"
  cidr_block        = "10.2.10.0/24"
  availability_zone = "ap-guangzhou-3"
}

resource "tencentcloud_eks_cluster" "foo" {
  cluster_name = "tf-test-eks"
  k8s_version  = "1.18.4"
  vpc_id       = tencentcloud_vpc.vpc.id
  subnet_ids = [
    tencentcloud_subnet.sub.id,
    tencentcloud_subnet.sub2.id,
  ]
  cluster_desc      = "test eks cluster created by terraform"
  service_subnet_id = tencentcloud_subnet.sub.id
  dns_servers {
    domain  = "www.example1.com"
    servers = ["1.1.1.1:8080", "1.1.1.1:8081", "1.1.1.1:8082"]
  }
  enable_vpc_core_dns = true
  need_delete_cbs     = true
  tags = {
    hello = "world"
  }
}
```

## Argument Reference

The following arguments are supported:

* `cluster_name` - (Required) Name of EKS cluster.
* `k8s_version` - (Required, ForceNew) Kubernetes version of EKS cluster.
* `subnet_ids` - (Required) Subnet Ids for EKS cluster.
* `vpc_id` - (Required, ForceNew) Vpc Id of EKS cluster.
* `cluster_desc` - (Optional) Description of EKS cluster.
* `dns_servers` - (Optional) List of cluster custom DNS Server info.
* `enable_vpc_core_dns` - (Optional, ForceNew) Indicates whether to enable dns in user cluster, default value is `true`.
* `extra_param` - (Optional, ForceNew) Extend parameters.
* `need_delete_cbs` - (Optional) Delete CBS after EKS cluster remove.
* `service_subnet_id` - (Optional) Subnet id of service.
* `tags` - (Optional) Tags of EKS cluster.

The `dns_servers` object supports the following:

* `domain` - (Optional) DNS Server domain. Empty indicates all domain.
* `servers` - (Optional) List of DNS Server IP address, pattern: "ip[:port]".

## Attributes Reference

In addition to all arguments above, the following attributes are exported:

* `id` - ID of the resource.



## Import

```
terraform import tencentcloud_eks_cluster.foo cluster-id
```

