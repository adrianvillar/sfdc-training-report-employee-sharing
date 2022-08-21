/*
* https://github.com/mmilidoni/sfdc-training-report-employee-sharing
* 
* MIT License 
* Copyright (c) 2022 Michele Milidoni
* 
*/

public class TrainingReportEmployeeShareRecalcBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([SELECT Id, Employee__c
        FROM Training_Report__c]);
    }

    public void execute(Database.BatchableContext BC, List<Training_Report__c> scope) {
        TrainingReports trs = new TrainingReports(scope);
        trs.unshareWithEmployee();
        trs.shareWithEmployee();
    }

    public void finish(Database.BatchableContext BC){}
}