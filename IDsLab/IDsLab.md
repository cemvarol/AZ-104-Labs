## Instructions

### Exercise 0: Prepare the lab environment


#### Task 1: Deploy an Azure VM for the Lab
1. Navigate to the [Azure portal](https://portal.azure.com), and  [Azure Shell](https://shell.azure.com)   sign in by your credentials.
1. In the **Cloud Shell**, select  **Bash** , run the command below to create a new vm for this exercise
3.	In the toolbar of the Cloud Shell pane, run the following command to create the vm.


      ```sh
      curl -O https://raw.githubusercontent.com/cemvarol/AZ-304-Labs/master/IDsLab/IDsLab-Resources.bash
      ls -la IDsLab-Resources.bash
      chmod +x IDsLab-Resources.bash
      ./IDsLab-Resources.bash
      ```
      
### Exercise 1: Create and Assign Managed Identity       
      
#### Task 1: Create the Managed Identity

Run the command below to create Managed Identity

```sh
az identity create --resource-group IDLab1 --name mid01
```

#### Task 2: Assign Managed Identity

Run the command below to assign the Mid to the new VM

```sh
az vm identity assign --resource-group IDLab1 --name IDs-VM01 --identities mid01
```


When you type exit, you left the powershell session. This is needed to load the installed components
#### Task 3: Assign Roles to Managed Identity

1.	In the Azure portal, assign reader role to mid01 on IDLab1
2.	In the Azure portal, assign owner role to mid01 on IDLab2


### Exercise 2: Use the assigned Managed Identity


#### Task 1: Connect to the Virtual Machine

1.  Select **Virtual machines** and, on the **Virtual machines** blade,
    select **IDs-VM0**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then
    click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***


#### Task 2: Prepare the Virtual Machine for Managed Identity
   >**Note:** This is a Core Operating system. You will only see command prompt window. Type powershell on the command prompt to start the powershell session.

1. Run the Commands in the  Powershell console to install Azure Powershell Library. **Please run them individually**

```powershell
Install-Module -Name PowerShellGet -Force
```
```powershell
Install-Module -Name Az -AllowClobber
```
```powershell
exit
```
   >**Note:** When you type exit, you left the powershell session. This is needed to load the installed components
   
   
Type powershell on the command prompt to start the powershell session again.

1. Run the Commands in the powershell console to assign the Managed identity. **Please run them individually**

```powershell
Install-Module -Name PowerShellGet -AllowPrerelease
```

```powershell
Install-Module -Name Az.ManagedServiceIdentity -AllowPrerelease
```

```powershell
Add-AzAccount -Identity
```


>**Note:** You have installed powershell library to your vm, and set your managed identity to use on that vm only.

#### Task 3: Use the Manaed Identity

From this point, the Azure Powershell commands will take actin on Azure Powershell Console directly. **Please run them individually**

1. Run the command below to get IDLab2 Resource Group location

```powershell
Get-AzResourceGroup -Name IDLab2
```

1. Run the command below to save IDLab2 Resource Group location to a variable

```powershell
$location = (Get-AzResourceGroup -Name IDLab2).Location
```

1. Run the command below to create a public Ip address under IDLab2, within the location saved to the variable. 

```powershell
New-AzPublicIpAddress -Name TstPip01 -ResourceGroupName IDLab2 -AllocationMethod Dynamic -Location $location
```

1. Run the command below to create a public Ip address under IDLab1, within the location saved to the variable
>**Note:** This will fail because Managed Identity has read permission on IDLab1

```powershell
New-AzPublicIpAddress -Name TstPip02 -ResourceGroupName IDLab1 -AllocationMethod Dynamic -Location $location
```

1. Run the command below to list the content of RGs **Please run them individually**

```powershell
Get-AzResource -ResourceGroupName "IDLab2"
```

```powershell
Get-AzResource -ResourceGroupName "IDLab1"
```


### Exercise 3: Remove Azure resources deployed in the lab


1. Navigate to Azure Portal from your lab Pc
1. From the Cloud Shell pane, run the following to list the resource group you created in this exercise:

   ```sh
   az group list --query "[?contains(name,'IDLab')]".name --output tsv
   ```

    > **Note**: Verify that the output contains only the resource group you created in this lab. This group will be deleted in this task.

1. From the Cloud Shell pane, run the following to delete the resource group you created in this lab

   ```sh
   az group list --query "[?contains(name,'IDLab')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
   ```

1. Close the Cloud Shell pane.

