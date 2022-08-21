/*
* https://github.com/mmilidoni/sfdc-training-report-employee-sharing
* 
* MIT License 
* Copyright (c) 2022 Michele Milidoni
* 
*/

public class TrainingReports extends fflib_SObjectDomain {
 
    public TrainingReports(List<Training_Report__c> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new TrainingReports(sObjectList);
        }
    }

    public override void onAfterInsert() {
        this.shareWithEmployee(Records);
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        List<Training_Report__c> recordsToUnshare = new List<Training_Report__c>();
        List<Training_Report__c> recordsToShare = new List<Training_Report__c>();

        for(Training_Report__c tr : (List<Training_Report__c>) Records) {
            Training_Report__c existingRecord = (Training_Report__c) existingRecords.get(tr.Id);
            if(tr.Employee__c != existingRecord.Employee__c) {
                recordsToUnshare.add(existingRecord);
                recordsToShare.add(tr);
            }
        }

        this.unshareWithEmployee(recordsToUnshare);
        this.shareWithEmployee(recordsToShare);
    }

    public void unshareWithEmployee() {
        this.unshareWithEmployee(Records);
    }
    public void shareWithEmployee() {
        this.shareWithEmployee(Records);
    }
    
    public void unshareWithEmployee(List<Training_Report__c> trs) {
        Map<Id, Training_Report__c> trsMap = new Map<Id, Training_Report__c>(trs);

        List<Training_Report__Share> sharedRecords = [SELECT Id 
            FROM Training_Report__Share
            WHERE ParentId IN :trsMap.keySet()
            AND RowCause = :Schema.Training_Report__Share.rowCause.Employee__c
        ];

        delete sharedRecords;
    }

    public void shareWithEmployee(List<Training_Report__c> trs) {
        List<Training_Report__Share> shareRecords = new List<Training_Report__Share>();
        for(Training_Report__c tr : trs) {
            if(tr.Employee__c != null) {
                shareRecords.add(new Training_Report__Share(
                    ParentId=tr.Id,
                    UserOrGroupId=tr.Employee__c,
                    RowCause=Schema.Training_Report__Share.rowCause.Employee__c,
                    AccessLevel='Read'
                ));
            }
        }

        insert shareRecords;
    }
}