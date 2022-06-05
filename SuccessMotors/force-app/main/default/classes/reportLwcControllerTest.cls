@isTest
public class reportLwcControllerTest {
    @testSetup
    static void setup() {
        List < Account > accs = new List < Account > ();
        List < Opportunity > opps = new List < Opportunity > ();

        for (Integer i = 0; i < 5; i++) {
            Account a = new Account(Name = 'Test Acc ' + i);
            insert a;
            for (Integer j = 0; j < 5; j++) {
                Opportunity opp = new Opportunity(Name = 'Test Opp ' + i, 
                                                  Amount = 100000, 
                                                  AccountId = a.Id, 
                                                  StageName = 'Closed Won', 
                                                  CloseDate = Date.newInstance(2022, 6, 10));
                opps.add(opp);
            }
        }

        insert opps;
    }

    @isTest
    static void mapAccountToOpportunitiesTest() {
        List < Account > accs = reportLwcController.mapAccountToOpportunities();
        for (Account a: accs) {
            System.assertEquals(500000, a.Closed_Opportunities_Sum__c);
        }
    }

    @isTest
    static void getAccountsTest() {
        List < Account > accs = reportLwcController.getAccounts();
        for (Account a: accs) {
            System.assertEquals(500000, a.Closed_Opportunities_Sum__c);
        }
    }

    @isTest
    static void searchAccountsTestForStringTerm() {
        List < Account > accs = reportLwcController.searchAccounts('Test Acc 1');
        System.assertEquals(1, accs.size());

        accs = reportLwcController.searchAccounts('');
        System.assertEquals(5, accs.size());

        accs = reportLwcController.searchAccounts('Test Acc');
        System.assertEquals(5, accs.size());
    }

    @isTest
    static void searchAccountsTestForDecimalTerm() {
        List < Account > accs = reportLwcController.searchAccounts('499000');
        System.assertEquals(5, accs.size());
    }

    @isTest
    static void getSingleAccountTest() {
        Account acc = [SELECT Id
            FROM Account
            WHERE Name = 'Test Acc 1'
        ];
        Account result = reportLwcController.getSingleAccount(acc.Id);

        System.assertEquals('Test Acc 1', result.Name);
    }
}