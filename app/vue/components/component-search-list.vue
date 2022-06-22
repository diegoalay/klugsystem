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
            },
            filterCols: {
                default: 0,
                type: Number
            },
        },

        data(){
            return {
                text: '',
                timer: null
            }
        },

        mounted(){
            this.text = this.defaultValue
        },

        methods: {
            search(){
                clearTimeout(this.timer)

                this.timer = setTimeout(() => {
                    this.$emit("search", this.text)
                }, 500);
            },
            clearInput(){
                this.text = ''

                this.$nextTick(()=> {
                    this.$refs['input'].focus()
                })
            }
        },

        watch: {
            text(value){
                this.search()
            },

            defaultValue(value) {
                this.text = value
            }
        }
    }
</script>

<template>
    <b-form-group>
        <b-row>
            <b-col>
                <b-input-group>
                    <b-form-input
                        ref="input"
                        id="filterInput"
                        :placeholder="placeholderText"
                        v-model="text"
                    >
                    </b-form-input>
                    <b-input-group-append>
                        <b-button :disabled="!text" @click="clearInput()"><font-awesome-icon icon="xmark" /></b-button>
                    </b-input-group-append>
                </b-input-group>
            </b-col>
            <b-col cols="0" v-if="!tools.isMobile()">
                <div class="float-right">
                    <template name="filters">
                        <b-input-group>
                            <slot>
                            </slot>
                        </b-input-group>
                    </template>
                </div>
            </b-col>
            <b-col v-if="tools.isMobile()" sm="12">
                <div class="float-right">
                    <template name="filters">
                        <br>
                        <slot>
                        </slot>
                    </template>
                </div>
            </b-col>
        </b-row>
    </b-form-group>
</template>