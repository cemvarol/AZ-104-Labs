#### Task 3: Check the output

1.  Go back to Azure portal and navigate to newly created Resource Group. Click the Traffic Manager **Lab-03-TM**
2.  On the overview page you will see 2 Endpoints. Ensure that Onprem is Online, and Migrated is Degraded.
       
    | Name | Status | Monitor Status |
    | --- | --- |--- |
    | Onprem | Enabled | **Online**|
    |Migrated | Enabled |**Degraded**|
    
2.  Copy the **DNS Name** and visit that URL on a new tab on your browser
3.  Ensure that the page welcomes you with the current date



