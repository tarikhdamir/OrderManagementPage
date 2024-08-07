import { LightningElement, track } from 'lwc';

export default class SearchBox extends LightningElement {
    @track searchTerm = '';

    handleSearch(event) {
        this.searchTerm = event.detail.value;
        const searchEvent = new CustomEvent('searchchange', {
            detail: this.searchTerm
        });
        this.dispatchEvent(searchEvent);
    }
}
