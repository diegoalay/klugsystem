<script type="text/javascript">
import ComponentDialogDelete from 'vueApp/components/component-dialog-delete.vue'
import componenSaleEmails from 'vueApp/components/sales/component-sale-emails.vue'

export default {
    props: {
        app_module: {
            require: true,
            type: String
        },
        controller: {
            type: String,
            default: 'sales'
        },
        cashRegisterId: {
            type: Number,
            default: null
        },
        hideHeader: {
            type: Boolean,
            default: false
        },
        userCreatorTypes: {
            type: Boolean,
            default: false
        },
        validateCashRegister: {
            type: Boolean,
            default: false
        },
        initFilters: {
            type: Object,
            default: () => { return {} }
        },
        titleHeader: {
            type: String,
            default: 'Ventas'
        },
        buttonHeader: {
            type: String,
            default: 'Vender'
        },
        origin: {
            type: String,
            default: ''
        },
        hiddenColumns: {
            type: Array,
            default: () => { return [] }
        },
        storedFilters: {
            type: Boolean,
            default: false
        }
    },
    components: {
        'component-sale-emails': componenSaleEmails
    },
    data() {
        return {
            data: [],
            fields: [{
                label: 'Fecha',
                key: 'created_at',
                sortable: true
            },{
                label: 'Estado',
                key: 'status',
                sortable: true
            },{
                label: 'Tipo de venta',
                key: 'sale_type',
                sortable: true
            },{
                label: 'Método de pago',
                key: 'payment_method',
                sortable: true
            },{
                label: 'Cliente',
                key: 'client_blling_name',
                sortable: true
            },{
                label: 'Nit',
                key: 'client_billing_identifier',
                sortable: true
            },{
                label: 'Subtotal',
                key: 'subtotal',
                sortable: true
            },{
                label: 'Descuento',
                key: 'discount',
                sortable: true
            },{
                label: 'Intéres',
                key: 'interest',
                sortable: true
            },{
                label: 'Total',
                key: 'total',
                sortable: true
            },{
                label: '',
                key: 'actions',
                sortable: false
            }],
            pagination: {
                total: 0,
                per_page: 10,
                current_page: 1,
                order_by: 'created_at',
                order: true,
            },
            options: {
                payment_methods: [],
                sale_types: []
            },
            filters: {
                status:'',
                search: '',
                sale_type: '',
                employee_id: '',
                payment_method: '',
                user_creator_type: '',
                cash_register_id: '',
                date_range: []
            },
            sale: {},
            loading: false,
            timer: null
        }
    },
    mounted() {
        if (this.data.copySaleId) {
            this.copySale()
        }
    },
    methods: {
        copySale(){

        },
        watchProps(){
            this.$set(this.filters, 'origin', this.origin) // bills source

            if (this.app_module ===  'finance') {
                if (this.cashRegisterId) {
                    this.$set(this.filters, 'cash_register_id', this.cashRegisterId)
                }

                this.addUserCreatorColumn()
            } else if (this.app_module === 'pos'){
                this.$set(this.filters, 'user_creator_type', 'current_cash_register')
            } else if (this.app_module === 'reports') {
                this.addUserCreatorColumn()
            }


            if ((this.store.global.cash_register.id && this.validateCashRegister) || (!this.validateCashRegister)) {
                this.list()
                this.getOptions()
            } else {
                const url = this.url.pos('cash_register').toString(false)
                this.$router.push(url)
            }

            for(let key in this.filters) {
                if (key === 'date_range' && this.initFilters[key]) {
                    this.$set(this.filters, key, [
                        new Date(this.initFilters[key][0]),
                        new Date(this.initFilters[key][1]),
                    ])
                } else if (this.initFilters[key]) {
                    this.$set(this.filters, key, this.initFilters[key])
                }
            }

            if (this.storedFilters) {
                const filters = this.storage.local(`${this.app_module}/${this.controller}`)

                for(let key in filters) {
                    const value = filters[key]

                    if (value) {
                        this.$set(this.filters, key, value)
                    }
                }
            }

            for (let column of this.hiddenColumns) {
                this.fields = this.fields.filter(e => e.key !== column)
            }
        },
        list(){
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.loading = true

                let filters = null

                if (this.filters.date_range.length > 0){
                    filters = {
                        ...this.filters,
                        start_date: this.filters.date_range[0] ?
                            this.filters.date_range[0].toISOString() :
                            '',
                        end_date: this.filters.date_range[1] ?
                            this.filters.date_range[1].toISOString() :
                            ''
                    }
                } else {
                    filters = this.filters
                }

                const url = this.url[this.app_module]('sales')
                .filters(filters)
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.records
                        this.pagination.total = response.data.total_count

                        this.$emit('change', filters)
                    } else {
                        this.$toast.error(result.error.message)
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            }, 200)
        },


        async disableSale(sale){
            const resp = await this.$dialog.confirm(
                {
                    title: '¿Esta seguro que desea deshabilitar la venta?',
                    text: 'Esta acción volverá a añadir los productos descontados del inventario.',
                    actions: [
                        {
                            text: 'Confirmar',
                            color: 'success',
                            key: true,
                        },
                        {
                            text: 'Cancelar',
                            color: 'danger',
                            key: false,
                        },
                    ]
                }
            )
            if (resp === true) {
                const form = {
                    sale: {
                        status: false
                    }
                }

                if (sale.sale_type === 'electronic_bill') this.$loading(true)
                const url = this.url[this.app_module]('sales/:id', {id: sale.id})
                this.http.put(url, form).then(result => {
                    if (sale.sale_type === 'electronic_bill') this.$loading(false)

                    if (result.successful) {
                        if (sale.sale_type !== 'electronic_bill' || (sale.sale_type === 'electronic_bill' && !result.data.status)) {
                            this.$toast.success('Venta deshabilitada exitosamente.')

                            const index = this.data.findIndex(e => e.id === sale.id)
                            this.$set(this.data[index], 'status', false)

                            this.$emit('change', this.filters)
                        } else {
                            // error in electronic bill annulment
                            this.$toast.error(result.data.annulment_error||'Error al anular la factura electrónica.', {
                                timeout: 4000
                            })
                        }
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        addUserCreatorColumn(){
            this.fields.splice(this.fields.length - 1, 0, {
                label: 'Usuario creador',
                key: 'user_creator_name',
                sortable: true
            })
        },


        employeeColumn(){
            this.fields.splice(this.fields.length - 1, 0, {
                label: 'Empleado',
                key: 'employee_name',
                sortable: true
            })
        },

        getOptions(){
            const url = this.url[this.app_module]('sales/options').filters({action: 'index'})

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data

                    if (this.cashRegisterId || this.app_module === 'reports' || this.app_module === 'pos') {
                        const user_creator_types = this.options.user_creator_types.filter(e => e.value !== 'current_cash_register')

                        this.$set(this.options, 'user_creator_types', user_creator_types)
                    }

                    if (this.employeeHeader()) this.employeeColumn()
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        copySale(sale){
            this.$set(this.store, 'copySaleId', sale.id)

            this.$router.push(`/${this.app_module}/${this.controller}/new`)
        },

        showSale(sale){
            if (this.app_module === 'reports') return

            this.$router.push(this.url[this.app_module](`${this.controller}/:id`, {id: sale.id}).toString(false))
        },

        sendSale(sale){
            this.sale = sale
            this.$bvModal.show('emails')
        },

        // sendSaleViaWP(sale){
        //     window.location = 'https://wa.me/+50243703704?text=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII='
        // },

        onSearch(text){
            this.filters.search = text

            this.list()
        },

        onFiltered(filteredItems) {
            this.totalRows = filteredItems.length
            this.currentPage = 1
        },

        employeeHeader(){
            return this.options.billing_employee_presence ? true : false
        }
    },

    watch: {
        'pagination.current_page'() {
            this.list()
        },

        'pagination.order_by'() {
            this.list()
        },

        'pagination.order'(){
            this.list()
        },

        'filters.date_range'(){
            this.list()
        },
        $props: {
            handler() {
                this.watchProps()
            },
            deep: true,
            immediate: true
        },
        filters: {
            handler(){
                this.storage.local(`${this.app_module}/${this.controller}`, this.filters)
            },
            deep: true
        }
    }
}
</script>

<template>
    <section>
        <b-modal
            id="emails"
            size="xl"
            hide-footer
            centered
            content-class="shadow"
            title="Correos enviados"
        >
            <component-sale-emails :app_module="app_module" :sale-id="sale.id" :email="sale.client_billing_email"/>
        </b-modal>

        <component-header-list
            v-if="!hideHeader"
            :title="titleHeader"
            :title-button-create="buttonHeader"
            :loading="loading"
            @reloadList="list"
        >
        </component-header-list>

        <b-card>
            <component-search-list :loading="loading" @search="onSearch">
                <slot name="filters">
                    <b-form-select
                        v-if="userCreatorTypes"
                        v-model="filters.user_creator_type"
                        :options="options.user_creator_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todas las ventas </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <b-form-select
                        v-model="filters.sale_type"
                        :options="options.sale_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todos los tipos de ventas </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <b-form-select
                        v-model="filters.payment_method"
                        :options="options.payment_methods"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todos los métodos de pago </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <template v-if="employeeHeader()">
                        <b-form-select
                            v-model="filters.employee_id"
                            :options="options.employees"
                            @change="list()"
                        >
                            <template #first>
                                <option value=""> Todos los empleados </option>
                            </template>
                        </b-form-select>
                        &nbsp;
                    </template>
                    <b-form-select
                        v-model="filters.status"
                        :options="options.statuses"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todos los estados </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <component-datepicker
                        v-if="filters.date_range.length > 0"
                        v-model="filters.date_range"
                        lang="es"
                        format="DD-MM-YYYY"
                        range
                        placeholder="Seleccione un rango de fechas"
                    >
                    </component-datepicker>
                </slot>
            </component-search-list>
            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="data"
                    :fields="fields"
                    @filtered="onFiltered"
                    @row-clicked="showSale"
                    :sort-desc.sync="pagination.order"
                    :sort-by.sync="pagination.order_by"
                    responsive
                >
                    <template #head()="{ label, field: { key, sortable }}">
                        {{ label }}
                        <template v-if="sortable">
                            <template>
                                <font-awesome-icon v-if="((pagination.order) && (pagination.order_by === key))" icon="sort-down" />
                                <font-awesome-icon v-else-if="((!pagination.order) && (pagination.order_by === key))" icon="sort-up" />
                            </template>
                        </template>
                    </template>

                    <template v-slot:cell(status)="row">
                        <div v-if="row.item.status" class="p-1 text-success">
                            {{ 'Activa' }}
                        </div>
                        <div v-else class="p-1 text-danger">
                            {{ 'Anulada' }}
                        </div>
                    </template>

                    <template v-slot:cell(created_at)="row">
                        {{ date.datetime(row.item.created_at) }}
                    </template>

                    <template v-slot:cell(sale_type)="row">
                        {{ row.item.sale_type_text }}
                    </template>

                    <template v-slot:cell(subtotal)="row">
                        {{ number.formatCurrency(row.item.subtotal) }}
                    </template>

                    <template v-slot:cell(discount)="row">
                        {{ number.formatCurrency(row.item.discount) }}
                    </template>

                    <template v-slot:cell(interest)="row">
                        {{ number.formatCurrency(row.item.interest) }}
                    </template>

                    <template v-slot:cell(total)="row">
                        {{ number.formatCurrency(row.item.total) }}
                    </template>

                    <template v-slot:cell(actions)="row">
                        <b-button
                            @click="tools.printSale(row.item)"
                            variant="outline-dark" class="mr-1"
                        >
                            <font-awesome-icon icon="print" />
                        </b-button>

                        <b-button
                            v-if="app_module !== 'reports'"
                            @click="sendSale(row.item)"
                            variant="outline-primary"
                            class="mr-1"
                        >
                            <font-awesome-icon icon="envelope-open-text" />
                        </b-button>
<!--
                        <b-button
                            v-if="app_module !== 'reports'"
                            @click="sendSaleViaWP(row.item)"
                            variant="outline-success"
                            class="mr-1"
                        >
                            <font-awesome-icon :icon="['fab', 'whatsapp']" />
                        </b-button> -->

                        <b-button
                            v-if="controller === 'bills'"
                            @click="copySale(row.item)"
                            variant="outline-info"
                            class="mr-1"
                        >
                            <font-awesome-icon icon="copy" />
                        </b-button>

                        <b-button
                            v-if="row.item.can_be_disabled && row.item.status && app_module !== 'reports'"
                            @click="disableSale(row.item)"
                            variant="outline-danger"
                            class="mr-1"
                        >
                            <font-awesome-icon icon="xmark" />
                        </b-button>
                    </template>
                </b-table>
                <b-col sm="4" md="4" class="my-1">
                    <b-pagination
                        v-model="pagination.current_page"
                        :simple="false"
                        :total-rows="pagination.total"
                        :per-page="pagination.per_page"
                        align="fill"
                        size="sm"
                        class="my-0"
                    ></b-pagination>
                </b-col>
            </b-card-body>
        </b-card>
    </section>
</template>