<script>
import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'

export default {
    props: {
        account: {
            required: true,
            type: Object
        }
    },
    components:{
        'component-autocomplete': componenentAutocomplete
    },
    data() {
        return {
            options: {
                sale_types: []
            }
        }
    },
    beforeMount() {
        this.getOptions()
    },
    methods: {
        getOptions(){
            const url = this.url.admin('account/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putForm(){
            const url = this.url.admin('account')
            let form = {
                account: this.account
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Configuración de cuenta actualizada exitosamente.')

                    this.$set(this.store.global, 'account', result.data)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getSaleTypeText(value) {
            const find = this.options.sale_types.find(e => e.value == value)

            if (find) {
                return find.text
            }

            return ''
        }
    },
    computed: {
        availableOptions() {
            return this.options.sale_types.filter(
                sale_type => this.account.sale_types.indexOf(sale_type.value) === -1
            )
        }
    }
}
</script>

<template>
    <b-form @submit.prevent="putForm">
        <b-card>
            <b-card-body>
                <b-row>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                NIT de facturación <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="account.billing_identifier"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                Nombre de facturación <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="account.billing_name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                Dirección de facturación <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="account.billing_address"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col md="3" sm="12">
                        <b-form-group label="Facturación electrónica">
                            <b-form-checkbox
                                v-model="account.electronic_billing"
                            >
                                {{ account.electronic_billing ? 'Deshabilitar' : 'Habilitar'}}
                            </b-form-checkbox>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                ¿ Elegir empleado al vender ?
                            </template>

                            <b-form-checkbox
                                v-model="account.billing_employee_presence"
                            >
                                {{ account.billing_employee_presence ? 'Deshabilitar' : 'Habilitar'}}
                            </b-form-checkbox>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                ¿ Considerar el límite del inventario al vender ?
                            </template>

                            <b-form-checkbox
                                v-model="account.inventory_count"
                            >
                                {{ account.inventory_count ? 'Deshabilitar' : 'Habilitar'}}
                            </b-form-checkbox>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                ¿ Permite cambiar el precio del producto al vender ?
                            </template>

                            <b-form-checkbox v-model="account.product_price_editable">
                                {{ account.product_price_editable ? 'Deshabilitar' : 'Habilitar'}}
                            </b-form-checkbox>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                ¿ Permite cambiar el nombre del producto al vender ?
                            </template>

                            <b-form-checkbox v-model="account.product_name_editable">
                                {{ account.product_name_editable ? 'Deshabilitar' : 'Habilitar'}}
                            </b-form-checkbox>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-form-group>
                    <template #label>
                        Tipos de venta
                    </template>

                    <b-form-tags
                        v-if="options.sale_types.length > 0"
                        id="tags-component-select"
                        v-model="account.sale_types"
                        size="lg"
                        class="mb-10 pb-10"
                        add-on-change
                        no-outer-focus
                    >
                        <template v-slot="{ tags, inputAttrs, inputHandlers, disabled, removeTag }">
                            <b-form-select
                                v-bind="inputAttrs"
                                v-on="inputHandlers"
                                :disabled="disabled || options.sale_types.length === 0"
                                :options="availableOptions"
                            >
                                <template #first>
                                    <!-- This is required to prevent bugs with Safari -->
                                    <option disabled value="">Elegir tipos de venta ...</option>
                                </template>
                            </b-form-select>
                            <br>
                            <br>
                            <ul v-if="tags.length > 0" class="list-inline d-inline-block mb-2">
                                <li v-for="tag in tags" :key="tag" class="list-inline-item">
                                <b-form-tag
                                    @remove="removeTag(tag)"
                                    :title="tag"
                                    variant="info"
                                >
                                    {{ getSaleTypeText(tag) }}
                                </b-form-tag>
                                </li>
                            </ul>
                        </template>
                    </b-form-tags>
                </b-form-group>
                <br>

                <b-form-group>
                    <template #label>
                        Cliente predeterminado
                    </template>

                    <component-autocomplete
                        :default-option-id="account.sale_client_id"
                        @select="(option) => account.sale_client_id = option ? option.id : null"
                        text-field="billing_details"
                        placeholder="Buscar por número de nit o nombre de facturación"
                        :endpoint="url.crm('/clients/search').toString(false)"
                    />
                </b-form-group>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>

<style scoped>
.badge {
    font-size: 14px;
    padding: 0.5em 0.5em !important;
}

</style>