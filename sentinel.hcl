policy "azure-cis-7.1-compute-managed-disk-encryption-is-enabled" {
  source = "https://github.com/hashicorp/terraform-guides/blob/master/governance/third-generation/azure/restrict-vm-size.sentinel"
  enforcement_level = "advisory"
}
