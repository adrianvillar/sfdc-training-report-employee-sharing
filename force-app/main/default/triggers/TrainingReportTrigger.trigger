/*
* https://github.com/mmilidoni/sfdc-training-report-employee-sharing
* 
* MIT License 
* Copyright (c) 2022 Michele Milidoni
* 
*/

trigger TrainingReportTrigger on Training_Report__c (after insert, after update) {

    fflib_SObjectDomain.triggerHandler(TrainingReports.class);

}