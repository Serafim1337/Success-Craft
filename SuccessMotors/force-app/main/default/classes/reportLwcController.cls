public with sharing class reportLwcController {

    public static List < Account > CACHED_ACCOUNTS = null;

    public static List < Account > mapAccountToOpportunities() {

        if (CACHED_ACCOUNTS == null) {

            List < Account > accountsNotFiltered = [SELECT Name, Closed_Opportunities_Sum__c, (SELECT Id, Name, Amount, CreatedDate, CloseDate FROM Opportunities WHERE IsClosed = TRUE AND IsWon = TRUE)
                FROM Account
                WITH SECURITY_ENFORCED
            ];

            List<Account> accounts = new List<Account>();

            for(Account a : accountsNotFiltered) {
                List<Opportunity> opp = a.Opportunities;
                if(opp.size() > 0) {
                    accounts.add(a);
                }
            }

            List < AggregateResult > sums = [SELECT AccountId, SUM(Amount)
                FROM Opportunity
                WHERE AccountId IN: accounts AND IsClosed = TRUE AND IsWon = TRUE
                WITH SECURITY_ENFORCED
                GROUP BY AccountId
            ];

            List < Account > accsToUpdate = new List < Account > ();

            for (Account a: accounts) {

                for (AggregateResult s: sums) {
                    if (s.get('AccountId') == a.Id) {
                        a.Closed_Opportunities_Sum__c = (Decimal) s.get('expr0');
                        accsToUpdate.add(a);
                    }
                }

            }

            CACHED_ACCOUNTS = accounts;

            return accounts;

        } else {
            return CACHED_ACCOUNTS;
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<OpportunityLineItem> getProducts(String oppId) {
        List<OpportunityLineItem> products = [SELECT Id, PricebookEntry.Name, Quantity, ListPrice, TotalPrice
        FROM OpportunityLineItem
        WHERE OpportunityId=:oppId];


        return products;
    }

    @AuraEnabled(cacheable = true)
    public static List < Account > getAccounts() {

        return mapAccountToOpportunities();
    }

    @AuraEnabled(cacheable = true)
    public static List < Account > searchAccounts(String searchTerm) {

        searchTerm = searchTerm.trim();

        if (searchTerm == '') {
            return getAccounts();
        }

        Decimal decimalTerm = null;

        try {
            decimalTerm = Decimal.valueOf(searchTerm);
        } catch (TypeException e) {

        }

        List < Account > accountsToSearch = mapAccountToOpportunities();
        List < Account > accountsToReturn = new List < Account > ();

        if (decimalTerm == null) {
            for (Account a: accountsToSearch) {
                if (a.Name.toLowerCase().contains(searchTerm.toLowerCase())) {
                    accountsToReturn.add(a);
                }
            }
        } else {
            for (Account a: accountsToSearch) {
                if ((Decimal) a.Closed_Opportunities_Sum__c >= decimalTerm) {
                    accountsToReturn.add(a);
                }
            }
        }

        return accountsToReturn;
    }

    @AuraEnabled(cacheable = true)
    public static Account getSingleAccount(String accountId) {
        List < Account > accountsToSearch = mapAccountToOpportunities();
        Account accountToReturn;
        for (Account a: accountsToSearch) {
            if ((String) a.Id == accountId) {
                accountToReturn = a;
            }
        }
        return accountToReturn;
    }
}