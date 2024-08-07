import { LightningElement, wire } from 'lwc';
import getAccountDetails from '@salesforce/apex/accountController.getAccountDetails';
import { CurrentPageReference } from 'lightning/navigation';

export default class AccountInfo extends LightningElement {
    accountId;
    accountName;
    accountNumber;
    error;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference) {
            this.accountId = currentPageReference.state.c__accountId;
        }
    }

    @wire(getAccountDetails, { accountId: '$accountId' })
    wiredAccount({ error, data }) {
        if (data) {
            this.accountName = data.Name;
            this.accountNumber = data.AccountNumber;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accountName = undefined;
            this.accountNumber = undefined;
        }
    }
}
