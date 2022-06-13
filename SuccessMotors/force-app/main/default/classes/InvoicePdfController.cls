public class InvoicePdfController {

    public Organization myOrg {
        get;
        set;
    }

    public Opportunity currentRecord {
        get;
        set;
    }

    public User oppOwner {
        get;
        set;
    }

    public OpportunityContactRole oppContRole {
        get;
        set;
    }

    public Contact oppContact {
        get;
        set;
    }

    public Account oppContactCompany {
        get;
        set;
    }

    public List < OpportunityLineItem > products {
        get;
        set;
    }

    public Decimal balance {
        get;
        set;
    }

    public String tableHeight {
        get;
        set;
    }


    public InvoicePdfController() {
        this.myOrg = [SELECT o.Name, o.Country, o.City, o.Street, o.PostalCode, o.State
            FROM Organization o
        ];

        if (!Test.isRunningTest()) {
            this.currentRecord = [SELECT Id, OwnerId, Name, Invoice_Number__c
                FROM Opportunity
                WHERE Id =: ApexPages.currentPage().getParameters().get('id')
            ];
        } else {
            this.currentRecord = [SELECT Id, OwnerId, Name, Invoice_Number__c
                FROM Opportunity
                WHERE Name = 'oppTest'
            ];
        }

        this.oppOwner = [SELECT Name
            FROM User
            WHERE id =: this.currentRecord.OwnerId
        ];
        this.oppContRole = [SELECT ContactId
            FROM OpportunityContactRole
            WHERE OpportunityId =: this.currentRecord.Id AND isPrimary = true
        ];
        this.oppContact = [SELECT AccountId, Name, Phone, Email
            FROM Contact
            WHERE Id =: this.oppContRole.ContactId
        ];


        this.oppContactCompany = [SELECT Name
            FROM Account
            WHERE Id =: this.oppContact.AccountId
        ];

        this.products = [SELECT Name, Quantity, TotalPrice, ListPrice
            FROM OpportunityLineItem
            WHERE OpportunityId =: this.currentRecord.Id
        ];

        Decimal priceSum = 0;
        Integer productCounter = 0;
        for (OpportunityLineItem p: products) {
            priceSum += p.TotalPrice;
            productCounter++;
        }

        this.balance = priceSum;

        this.tableHeight = productCounter * 70 + 120 + 'px';
    }

}