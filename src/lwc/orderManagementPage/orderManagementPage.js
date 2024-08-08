import { LightningElement, track } from 'lwc';

export default class ProductPage extends LightningElement {
    @track filters = {};
    @track searchTerm = '';

    handleFilterChange(event) {
        this.filters = { ...event.detail };
        console.log('Updated Filters:', this.filters);
        this.template.querySelector('c-product-list').refreshProducts();
    }

    handleSearchChange(event) {
        // this.searchTerm = event.target.value;
        this.searchTerm = event.detail.searchTerm;
        console.log('Updated Search Term:', this.searchTerm);
        this.template.querySelector('c-product-list').refreshProducts();
    }

    handleProductCreated() {
        console.log("refresh called");
        this.template.querySelector('c-product-list').refreshProducts();
    }
}
