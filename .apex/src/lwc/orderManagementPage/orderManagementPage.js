import { LightningElement } from 'lwc';

export default class OrderManagementPage extends LightningElement {
    accountId;

    connectedCallback() {
        const urlParams = new URLSearchParams(window.location.search);
        this.accountId = urlParams.get('c__accountId');
        console.log('Account ID:', this.accountId); // Debugging log to check the accountId
    }
}
