<script type="text/javascript">
    export default {
        props: {
            placeholderText: {
                default: 'Buscar ...',
                type: String
            },
            defaultValue: {
                default: '',
                type: String
            }
        },

        data(){
            return {
                text: ''
            }
        },

        mounted(){
            this.text = this.defaultValue
        },

        methods: {
            search(){
                this.$emit("search", text)
            }
        },

        watch: {
            text(){
                this.search()
            }
        }
    }
</script>

<template>
    <b-form-group>
        <b-input-group>
            <b-form-input
                id="filterInput"
                :placeholder="placeholderText"
            >
            </b-form-input>
            <b-input-group-append>
                <b-button :disabled="!text" @click="text = ''"><font-awesome-icon icon="times" /></b-button>
            </b-input-group-append>
        </b-input-group>
    </b-form-group>
</template>