*** Settings ***

Resource        tests/NPSP.robot
Library           DateTime
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser

*** Test Cases ***

Create a new account and enter payment information
    #Create a new account and enter payment information, then process batch
    [tags]  unstable
    ${ns} =  Get NPSP Namespace Prefix
    &{batch} =       API Create DataImportBatch    Batch_Process_Size__c=50    Batch_Description__c=Created via API    Donation_Matching_Behavior__c=Single Match or Create    Donation_Matching_Rule__c=donation_amount__c;donation_date__c    RequireTotalMatch__c=false    Run_Opportunity_Rollups_while_Processing__c=true   GiftBatch__c=true    Active_Fields__c=[{"label":"Donation Amount","name":"${ns}Donation_Amount__c","sObjectName":"Opportunity","defaultValue":null,"required":true,"hide":false,"sortOrder":0,"type":"number","options":null},{"label":"Donation Date","name":"${ns}Donation_Date__c","sObjectName":"Opportunity","defaultValue":null,"required":false,"hide":false,"sortOrder":1,"type":"date","options":null}]     
    Select App Launcher Tab   Batch Gift Entry
    # Click Link  &{batch}[Name]
    Click Link With Text    &{batch}[Name]
    Select Value From BGE DD    Donor Type    Account
    ${acc_name} =  Generate Random String
    Populate Address    Search Accounts    ${acc_name}
    Click Element    title:Search Accounts...
    Wait For Locator    record.edit_button    New Account
    Click Element    title=New Account
    Select Record Type         Organization
    Populate Form
    ...                        Account Name=${acc_name}
    Click Modal Button         Save    
    Wait Until Modal Is Closed
    Fill BGE Form
    ...                       Donation Amount=20
    Select BGE Date Picker    Donation Date
    Click BGE Button    Today
    Click BGE Button       Save
    Reload Page
    Verify Row Count    1 
    Wait For Locator    bge.edit_button    Donation Amount
    SeleniumLibrary.Element Text Should Be    //td[@data-label="Donation"]//lightning-formatted-url    ${Empty}
    Sleep    1
    Click BGE Button       Process Batch
    Select Frame With Title    NPSP Data Import
    Click Button With Value   Begin Data Import Process
    Wait For Locator    data_imports.status    Completed
    Click Button With Value   Close
    ${value}    Return Locator Value    bge.value    Donation
    # Click Link    ${value}
    Click Link With Text    ${value}
    ${opp_name}    Return Locator Value    check_field    Opportunity
    Click Link    ${opp_name}
    Confirm Value    Amount    $20.00    Y 
    ${opp_date} =     Get Current Date    result_format=%-m/%-d/%Y
    Confirm Value    Close Date    ${opp_date}    Y 
    Confirm Value    Stage    Closed Won    Y
    # ${newopp_id}    Get Current Record ID
    # ${date} =     Get Current Date    result_format=%Y-%m-%d
    # &{new_opp} =  Salesforce Get    Opportunity    ${newopp_id}
    # Should Be Equal As Strings    &{new_opp}[Amount]    20.0
    # Should Be Equal As Strings    &{new_opp}[CloseDate]    ${date}
    # Should Be Equal As Strings    &{new_opp}[StageName]    Closed Won
    # Select Window
    Click Link With Text    text=${acc_name}
    
    
    
    