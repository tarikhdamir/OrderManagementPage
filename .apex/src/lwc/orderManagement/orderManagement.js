// import { LightningElement, api, wire } from 'lwc';
// import { NavigationMixin } from 'lightning/navigation';
//
// export default class OrderManagement extends NavigationMixin(LightningElement) {
//     @api recordId; // Account record ID
//
//     handleCreateOrder() {
//         const encodedAccountId = encodeURIComponent(this.recordId);
//         window.open(`/lightning/n/Order_Management_Page?accountId=${encodedAccountId}`, '_blank');
//     }
//
// }
//
// import { LightningElement, api } from 'lwc';
// import { NavigationMixin } from 'lightning/navigation';
//
// export default class OrderManagement extends NavigationMixin(LightningElement) {
//     @api recordId; // Account record ID
//
//     handleCreateOrder() {
//         const encodedAccountId = encodeURIComponent(this.recordId);
//         this[NavigationMixin.Navigate]({
//             type: 'standard__navItemPage',
//             attributes: {
//                 apiName: 'Order_Management_Page'
//             },
//             state: {
//                 c__accountId: encodedAccountId
//             }
//         }, true);
//     }
// }

import { LightningElement, api } from 'lwc';

export default class OrderManagement extends LightningElement {
    @api recordId; // Account record ID

    handleCreateOrder() {
        const encodedAccountId = encodeURIComponent(this.recordId);
        const baseUrl = window.location.origin;
        const navItemUrl = `/lightning/n/Order_Management_Page?c__accountId=${encodedAccountId}`;

        window.open(baseUrl + navItemUrl, '_blank');
    }
}
