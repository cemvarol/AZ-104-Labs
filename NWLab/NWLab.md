
# Lab: Configuring VNet peering and service chaining
  

### Lab Setup
  
Estimated Time: 45 minutes

User Name: **QA**

Password: **1q2w3e4r5t6y***


## Exercise 1: Creating the vms
 

#### Task 1: Create the vms

1. From the Cloud Shell pane, open a bash command line and run the script shown below


```sh
curl -O https://raw.githubusercontent.com/cemvarol/AZ-104-Labs/main/NWLab/NwLab-Resources.bash
ls -la NwLab-Resources.bash
chmod +x NwLab-Resources.bash
./NwLab-Resources.bash
```

## Exercise 2: Configuring VNet peering 

  
The task for this exercise is as follows:

1. Configure VNet peering for both virtual networks

#### Task 1: Configure VNet peering for both virtual networks
  
1. In the Microsoft Edge window displaying the Azure portal, navigate to the **VNet02** virtual network blade.

1. From the **VNet02** blade, create a VNet peering with the following settings:

    - Name of the peering from the first virtual network to the second virtual network: **VNet02-to-VNet01**

    - Virtual network deployment model: **Resource manager**

    - Subscription: the name of the Azure subscription you are using for this lab

    - Virtual network: **VNet01**
    
    - Name of the peering from the second virtual network to the first virtual network: **VNet01-to-VNet02**    
    
    - Allow virtual network access from the first virtual network to the second virtual nework: **Enabled**
    
    - Allow virtual network access from the second virtual network to the first virtual nework: **Enabled**    

    - Allow forwarded traffic from the first virtual network to the second virtual network: **Disabled**
    
    - Allow forwarded traffic from the second virtual network to the first virtual network: **Disabled**

    - Allow gateway transit: Ensure not checked
    
1. Confirm **VNet Peerings** are created on both VNets. 

## Exercise 3: Implementing routing
  
The main tasks for this exercise are as follows:

1. Enable IP forwarding

2. Configure user defined routing 

3. Configure routing on an Azure VM running Windows Server 2016


#### Task 1: Enable IP forwarding 
  
1. In Microsoft Edge, navigate to the **VM-RVMNic** blade (the NIC of **VM-R**)

2. On the **VM-RVMNic** blade, modify the **IP configurations** by setting **IP forwarding** to **Enabled**.


#### Task 2: Configure user defined routing 

1. In the Azure portal, Create a **New Route Table** with the following settings:

    - Name: **304NwLab-rt1**

    - Subscription: the name of the Azure subscription you use for this lab

    - Resource group: **304NwLab-RG01**

    - Location: the same Azure region in which you created the virtual networks
  
    - Virtual network gateway route propagation: **Disabled**
    
    Once the creation of the route table has finished, click on **Go to resource**

2. In the Azure portal, on the route table 304NwLab-rt1 that was created on the previous step, click on **Routes** under **Settings** and add a route with the following settings: 

    - Route name: **Custom-route-to-VNet02-Subnet01**

    - Address prefix: **10.1.1.0/24**

    - Next hop type: **Virtual appliance**

    - Next hop address: **172.16.2.4**

3. In the Azure portal, associate the route table with the **Subnet-1** of the **VNet01**, which is **VN01SN01**


#### Task 3: Configure routing on an Azure VM running Windows Server 2016

1. On the lab computer, from the Azure portal, start a Remote Desktop session to **VM-R** Azure VM. 

2. When prompted to authenticate, specify the following credentials:

    - User name: **QA**

    - Password: **1q2w3e4r5t6y***

3. Once you are connected to VM-R via the Remote Desktop session, 
Run these commands below on **powershell** console of that VM

---
 
**Set-NetFirewallProfile -Enabled False**

**Install-WindowsFeature Routing, RSAT-RemoteAccess**

**rrasmgmt.msc**

----

4. Follow the steps to complete RRAS setting... Check this image down below

![](https://raw.githubusercontent.com/cemvarol/AZ-301-Updates-Errors/master/M8/RouterConf.png)



> **Result**: After completing this exercise, you should have configured custom routing within the second virtual network.


#### Task 4: Turn off OS firewall on VM-X

1. On the lab computer, from the Azure portal, start a Remote Desktop session to **VM-X** Azure VM. 

2. When prompted to authenticate, specify the following credentials:

    - User name: **QA**

    - Password: **1q2w3e4r5t6y***

3. Once you are connected to VM-R via the Remote Desktop session, 
Run these commands below on **powershell** console of that VM

---
 
**Set-NetFirewallProfile -Enabled False**

----

## Exercise 4: Validating service chaining
  
The main tasks for this exercise are as follows:

1. Configure Windows Firewall with Advanced Security on an Azure VM

1. Test service chaining between peered virtual networks


#### Task 1: Configure Windows Firewall with Advanced Security on the target Azure VMs
  
1. On the lab computer, from the Azure portal, start a Remote Desktop session to **VM-B**. 

2. When prompted to authenticate, specify the following credentials:

    - User name: **QA**

    - Password: **1q2w3e4r5t6y***

3. In the Remote Desktop session to VM-B, run the **powershell** command below on that vm

**Set-NetFirewallProfile -Enabled False**

#### Task 2: Test service chaining between peered virtual networks
  
1. On the lab computer, from the Azure portal, start a Remote Desktop session to **VM-A**. 

1. When prompted to authenticate, specify the following credentials:

    - User name: **QA**

    - Password: **1q2w3e4r5t6y***

1. Once you are connected to **VM-A** via the Remote Desktop session, start **Windows PowerShell**.

1. In the **Windows PowerShell** window, run the following:

   ```pwsh
   Set-NetFirewallProfile -Enabled False
   
   Test-NetConnection -ComputerName 10.1.1.4 -TraceRoute
   ```
5. Verify that test is successful and note that the connection was routed over **172.16.2.4**

   Check this image down below
   
 ![](https://raw.githubusercontent.com/cemvarol/AZ-301-Updates-Errors/master/M8/VM-A-TraceResults.png)


>  **Result**: After completing this exercise, you should have validated service chaining between peered virtual networks.

#### Task 3: Verify connectivity via **Network Watcher**

1. At the top of the page search for **Network Watcher**.

1. Click **Next Hop** menu, under **Network diagnostic tools** 

1. On the **Network Watcher | Next hop** blade, perform the following tasks:

    - Leave the **Subscription** drop-down list entry set to its default value.

    - In the **Resource group** drop-down list, select the **304NwLab-RG01** entry.

    - In the **Virtual machine** drop-down list, choose **VM-A**.
    
    - In the **Network Interface** drop-down list, set to its default value.
    
    - In the **Source Ip Addess** option, set to its default value.

    - In the  **Destination IP Address** type **10.1.1.4**.
    
        - Ensure that the result shows **Next Hop Type** as **Virtual Appliance**. This means traffic is passing over 172.16.2.4 (VM-R) from VM-A to VM-B

    - In the  **Destination IP Address** replace **10.1.1.4** with **10.2.2.4**.
    
      - Ensure that the result shows **Next Hop Type** as **VirtualNetworkPeering**. This means traffic is passing over VNet Peering from VM-A to VM-X


> **Result**: This last task proves that Route Table associated with VN01SN01 is only working from that subnet to its target 10.1.1.0/24 subnet. When you try to reach a resource from 10.2.2.0/24 subnet, packages are transferred over VNet Peering still. 


![](https://raw.githubusercontent.com/cemvarol/AZ-301-Updates-Errors/master/M8/Result.png)



## Exercise 5: Remove lab resources


1. At the **Cloud Shell** command prompt, type in the following command and press **Enter** to delete all resource groups you created in this lab:


   ```sh
   az group list --query "[?contains(name,'NwLab')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
   ```

1. Close the **Cloud Shell** prompt at the bottom of the portal.

> **Result**: In this exercise, you removed the resources used in this lab.
