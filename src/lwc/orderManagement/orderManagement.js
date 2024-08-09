import { LightningElement, api } from 'lwc';

export default class OrderManagement extends LightningElement {
    @api recordId;

    handleCreateOrder() {
        const encodedAccountId = encodeURIComponent(this.recordId);
        const baseUrl = window.location.origin;
        const navItemUrl = `/lightning/n/Order_Management_Page?c__accountId=${encodedAccountId}`;

        window.open(baseUrl + navItemUrl, '_blank');
    }
}
