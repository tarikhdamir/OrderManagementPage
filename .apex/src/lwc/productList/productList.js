import { LightningElement, track, wire } from 'lwc';
import getFilteredProducts from '@salesforce/apex/ProductController.getFilteredProducts';

export default class ProductList extends LightningElement {
    @track products;
    @track error;
    @track filters = {};
    @track searchTerm = '';

    @wire(getFilteredProducts, { filters: '$filters', searchTerm: '$searchTerm' })
    wiredProducts({ error, data }) {
        if (data) {
            this.products = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.products = undefined;
        }
    }

    handleFilterChange(event) {
        this.filters = event.detail;
    }

    handleSearchChange(event) {
        this.searchTerm = event.detail;
    }
}
