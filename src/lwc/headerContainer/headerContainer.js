import {LightningElement, api} from 'lwc';

export default class HeaderContainer extends LightningElement {
    @api accountId

    handleProductCreated() {
        this.dispatchEvent(new CustomEvent('productcreated'));
    }
}