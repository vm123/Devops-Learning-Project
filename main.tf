provider "azurerm" {
  subscription_id = "5ec6ddd8-60a2-4186-9e32-59fbeab53734"
  client_id       = "27fda9b7-5c04-4a93-9498-40f6b864737e"
  client_secret   = "2AE8Q~U0tR9QWnehAwgz1uOUBPmqX_sdSejxpb76"
  tenant_id       = "413f938c-6491-4a79-ab15-40391f06e8f6"
  features {}
}

resource "azurerm_resource_group" "DataBase_Resource_Group" {
  name     = "DataBase_Resource_Group"
  location = "East US"
}

resource "azurerm_user_assigned_identity" "api" {
  resource_group_name = "DataBase_Resource_Group"
  location            = "East US"
  name                = "api"
}

resource "azurerm_storage_account" "devopsstorage513872" {
  name                     = "devopsstorage513872"
  resource_group_name      = "DataBase_Resource_Group"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mssql_server" "sqlserver84209" {
  name                          = "sqlserver84209"
  resource_group_name           = "DataBase_Resource_Group"
  location                      = "East US"
  version                       = "12.0"
  administrator_login           = "DevopsProj"
  administrator_login_password  = "MANNAVA-SMITH-2022m"
  connection_policy             = "Redirect"
  public_network_access_enabled = "true"

  identity {
    type         = "UserAssigned"
    identity_ids = ["/subscriptions/5ec6ddd8-60a2-4186-9e32-59fbeab53734/resourceGroups/DataBase_Resource_Group/providers/Microsoft.ManagedIdentity/userAssignedIdentities/api"]
  }
}

resource "azurerm_mssql_database" "heart8rate" {
  name      = "heart8rate"
  server_id = "/subscriptions/5ec6ddd8-60a2-4186-9e32-59fbeab53734/resourceGroups/DataBase_Resource_Group/providers/Microsoft.Sql/servers/sqlserver84209"
}

resource "azurerm_mssql_firewall_rule" "firewallruleVijay" {  #firewall to allow all IP address from local address
  name             = "firewallruleVijay"
  server_id        = "/subscriptions/5ec6ddd8-60a2-4186-9e32-59fbeab53734/resourceGroups/DataBase_Resource_Group/providers/Microsoft.Sql/servers/sqlserver84209"
  start_ip_address = "167.96.157.56"
  end_ip_address   = "167.96.157.56"
}

resource "azurerm_mssql_firewall_rule" "firewallruleAzure" {  #firewall to allow all IP address from Azure Services
  name             = "firewallruleAzure"
  server_id        = "/subscriptions/5ec6ddd8-60a2-4186-9e32-59fbeab53734/resourceGroups/DataBase_Resource_Group/providers/Microsoft.Sql/servers/sqlserver84209"
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
