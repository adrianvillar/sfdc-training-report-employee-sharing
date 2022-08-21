/*
* https://github.com/mmilidoni/sfdc-training-report-employee-sharing
* 
* MIT License 
* Copyright (c) 2022 Michele Milidoni
* 
*/

@IsTest
public class TrainingReportTest {
    
    @IsTest
    public static void testAll() {
        List<User> lstUser = new List<User>();
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        for(Integer i=0; i < 10; i++) {
            User u = new User(Alias = 'stdm' + i, Email='standarduser' + i + '@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='michelemstandarduser' + i + '@testorg.com');
            lstUser.add(u);
        }

        insert lstUser;

        List<Training_Report__c> trs = new List<Training_Report__c>();
        for(Integer i=0; i < 200; i++) {
            trs.add(new Training_Report__c(
                OwnerId=lstUser.get(0).Id,
                Employee__c=lstUser.get(1).Id
            ));
        }

        Test.startTest();
        insert trs;
        for(Training_Report__c tr : trs) {
            tr.Employee__c = lstUser.get(2).Id;
        }
        update trs;

        DataBase.executeBatch(new TrainingReportEmployeeShareRecalcBatch()); 

        Test.stopTest();


    }
}