
<script>
export default {
    props: {
        value: {
        },

        timeout: {
            type: Number,
            default: 300
        },

        endpoint: {
            type: String,
            required: true
        },

        placeholder: {
            type: String,
            default: ''
        },

        text: {
            type: String,
            default: ''
        },

        clearOptions: {
            type: Boolean,
            default: false
        },

        // Allows us to customize from where will we get the records
        // Default is result.data
        // If this variable is set, then we will get them from result.data[recordsKey]
        recordsKey: {
            default: null
        },

        keyField: {
            type: String,
            default: 'id'
        },

        // The backend param that is used to filter the results. Defaults to
        // search
        searchParam: {
            type: String,
            default: 'search'
        },

        textField: {
            type: String,
            default: 'id'
        },

        startingSearch: {
            type: String,
            default: ''
        },

        focus: {
            type: Boolean,
            default: false,
        },

        required: {
            type: Boolean,
            default: false
        },

        queryParams: {
            default: null
        },

        fullWidth: {
            type: Boolean,
            default: false
        },

        tabindex: {
            defaul: null
        },
        postNewEntries: {
            type: Boolean,
            default: false
        },

        defaultOptionId: {
            type: Number,
            default: null
        }
    },

    data() {
        return {
            search: '',
            disable_search: false,
            options: [],
            matching_options: [],
            index: -1,
            timer: null
        }
    },

    mounted(){
        this.disable_search = true;
        if(this.startingSearch){
            this.search = this.startingSearch;
        }

        this.$nextTick(()=>{
            this.disable_search = false;
        });

        if (this.defaultOptionId) {
            this.setDefaultOption()
        }
    },

    methods: {

        setListeners() {
            this.matching_options = this.$refs.list;
            if(this.matching_options){


                this.children = this.matching_options.querySelectorAll('li');

                this.matching_options.onkeydown = e =>{
                    if(e.keyCode == 8){
                        e.preventDefault();
                        if(this.search.length > 0){
                            this.search = this.search.slice(0, -1)
                        }
                        this.focusOnInput();
                    }
                }

                this.$refs.component.onkeydown = e => {
                    if([38, 40, 13].includes(e.keyCode)){
                        e.preventDefault()
                    }
                    switch (e.keyCode) {
                        case 38:
                            if (this.index >= 0) {
                                this.index--;
                            }
                            if(this.index < 0){
                                this.focusOnInput();
                                break;
                            }
                            this.children[this.index].focus();
                            break;
                        case 40:
                            if (this.index < this.children.length - 1) {
                                this.index++;
                            }
                            this.children[this.index].focus();
                            break;
                        case 13:
                            if(this.children[this.index]){
                                this.children[this.index].click();
                            }
                            break;
                    }
                };
            }
        },

        setDefaultOption(){
            let url = this.endpoint.replace('search', '')
            url = `${url}/${this.defaultOptionId}.json`

            this.http.get(url).then((response) => {
                if(response.successful){
                    this.$nextTick(()=>{
                        this.select(null, response.data, false)
                    })
                }else{

                }
            }).catch((err)=>{
                console.log(err)
            })
        },

        loadOptions() {
            let params = `filters[${this.searchParam}]=${this.search.toLowerCase()}`
            if(this.queryParams){
                params+=`&${this.queryParams}`
            }
            let url = `${this.endpoint}?${params}`

            this.http.get(url).then((response)=>{
                if(response.successful){
                    if(this.recordsKey){
                        this.options = response.data[this.recordsKey]
                    }else{
                        this.options = response.data
                    }
                    this.$nextTick(()=>{
                        this.setListeners();
                    })
                }else{
                    this.msg.error(response.error.message);
                }
            }).catch((err)=>{
                console.log(err);
            });
        },

        focusOnInput(){
            this.$refs['input'].focus()
        },

        select(e, option, focus = true) {
            if (e) {
                e.preventDefault();
            }

            this.disable_search = true;
            this.options = [];
            this.selected_option = option;
            this.search = option[this.textField];
            this.index = -1;
            this.$emit('input', option[this.keyField]);
            this.$emit('select', option)

            if (focus) {
                this.focusOnInput();
            }

            this.$nextTick(()=>{
                this.disable_search = false;
            });
        },

        verifySelectedOption(){
            if(! this.search){
                this.selected_option = null;
                this.$emit('input', null);
                this.$emit('clear')
                return
            }

            let selected_option = this.options.find((option)=>{
                return option[this.textField].toLowerCase() == this.search.toLowerCase()
            })

            if(selected_option){
                this.selected_option = selected_option;
                this.search = this.selected_option[this.textField];
                this.$emit('input', this.selected_option[this.keyField]);
                this.$emit('select', selected_option)
                if(this.options.length == 1){
                    this.disable_search = true;
                    this.options = [];
                    this.index = -1;
                    this.$nextTick(()=>{
                        this.disable_search = false;
                    });
                }
            }else{
                this.selected_option = null;
                this.$emit('select', null);
                this.$emit('input', null);
                this.$emit('clear')
            }
        },

        clearField(){
            this.search = '';
            this.disable_search = true;
            this.options = [];
            this.index = -1;
            this.$emit('input', null);
            this.$emit('clear')
            this.$nextTick(()=>{
                this.disable_search = false;
            });
        },

        clearAutocompleteOptions(){
            this.disable_search = true;
            this.options = [];
            this.index = -1;
            this.search = ''
            this.$nextTick(()=>{
                this.disable_search = false;
            });
        }
    },

    watch: {
        text(){
            if(this.text != this.search){
                this.disable_search = true;
                this.search = this.text
                this.$nextTick(()=>{
                    this.disable_search = false;
                });
            }
        },

        search(value) {
            if (! this.disable_search) {
                if (value !== '') {
                    clearTimeout(this.timer)

                    this.timer = setTimeout(() => {
                        this.loadOptions();
                    }, this.timeout)
                } else {
                    this.options = [];
                    this.index = -1;
                }
            }
            this.$emit('update:text', this.search)
        },

        clearOptions(){
            if(this.clearOptions){
                this.$emit('update:clear-options', false)
                this.clearAutocompleteOptions()
                this.focusOnInput()
            }
        },

        defaultOptionId(){
            this.setDefaultOption()
        }
    }
};
</script>
<template>
    <div ref="component">
        <div class="input-group">
            <b-form-input
                type="text"
                v-model="search"
                :tabindex="tabindex"
                :placeholder="placeholder"
                ref="input"
                :required="required"
                @change.native="verifySelectedOption"
                :focus="focus"
                autocomplete="off"
            >
            </b-form-input>
            <template name="buttons">
                <slot>
                  <b-input-group-prepend>
                      <b-button :disabled="!search" @click="search = ''"><font-awesome-icon icon="times" /></b-button>
                  </b-input-group-prepend>
                </slot>
            </template>
        </div>

        <ul
            :class="['list', 'is-hoverable', 'autocomplete-wrap', {'w-100': Boolean(fullWidth), 'w-20-rem': ! Boolean(fullWidth)}]"
            v-show="options.length > 0"
            ref="list"
        >
            <li
                class="list-group-item list-group-item-action"
                v-for="(option, index) in options"
                :key="option[keyField]"
                @click="select($event, option)"
                :tabindex="index + 1"
            >
                {{ option[textField] }}
            </li>
        </ul>
        <br>
    </div>
</template>
<style>
.autocomplete-wrap {
    background-color: #FFFFFF;
    position: absolute;
    z-index: 200;
}
.list-group-item.list-group-item-action:hover {
    cursor: pointer;
    background-color: rgb(220, 220, 220);
}

.list-group-item.list-group-item-action:focus {
    cursor: pointer;
    background-color: rgb(220, 220, 220);
}
.autocomplete-wrap li {
    padding: 0.5rem;
}
.w-100 {
    width: 80%;
}
.w-20-rem {
    width: 20rem;
}
</style>
