<script type="text/javascript">
export default {
    props: {
        saleId: {
            required: true,
            type: Number
        },
        app_module: {
            required: true,
            type: String
        },
        email: {
            type: String,
            default: null
        }
    },
    data() {
        return {
            records: [],
            fields: [{
                label: 'Fecha de envío',
                key: 'created_at',
                sortable: true
            },{
                label: 'E-Mail',
                key: 'description',
                sortable: true
            }],
            pagination: {
                total: 0,
                per_page: 10,
                current_page: 1
            },
            sorting: {
                desc: false,
                column: 'created_at'
            },
            search_text: '',
            loading: false,
            client_email: null,
        }
    },
    mounted() {
        this.client_email = this.email

        this.list()
    },
    methods: {
        list(){
            this.loading = true
            const url = this.url[this.app_module]('sales/:id/emails_sent', {id: this.saleId})

            this.http.get(url).then(response => {
                this.records = response.data
                this.pagination.total = this.records.length

                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },
        onSearch(text){
            this.search_text = text
        },
        onFiltered(filteredItems) {
            this.totalRows = filteredItems.length
            this.currentPage = 1
        },
        sendEmail(){
            const form = {
                client: {
                    email: this.client_email
                }
            }

            this.loading = true
            const url = this.url[this.app_module]('sales/:id/send_sale', {id: this.saleId })
            this.http.post(url, form).then(result => {
                this.loading = false
                if (result.successful) {
                    this.$toast.success('Factura enviada exitosamente.')

                    this.list()
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },
    watch: {
        saleId(){
            this.list()
        }
    }
}
</script>

<template>
    <section>
        <b-card>
            <b-form @submit.prevent="sendEmail">
                <b-row>
                    <b-col md="10" sm="12">
                        <b-form-group>
                            <template #label>
                                E-mail
                            </template>

                            <b-form-input
                                required
                                v-model="client_email"
                                type="email"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="2" sm="12">
                        <b-form-group>
                            <template #label>
                                Acción
                            </template>

                            <b-button v-if="loading" variant="primary" class="mb-2">
                                <font-awesome-icon icon="spinner" spin />
                                Enviando ...
                            </b-button>

                            <b-button v-else type="submit" variant="primary" block>
                                <font-awesome-icon icon="paper-plane" />
                            </b-button>
                        </b-form-group>
                    </b-col>
                </b-row>
            </b-form>

            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="records"
                    :fields="fields"
                    :current-page="pagination.current_page"
                    :per-page="pagination.per_page"
                    :filter="search_text"
                    @filtered="onFiltered"
                    :sort-desc.sync="sorting.desc"
                    :sort-by.sync="sorting.column"
                    responsive
                >
                    <template #head()="{ label, field: { key, sortable }}">
                        {{ label }}
                        <template v-if="sortable">
                            <template>
                                <font-awesome-icon v-if="((sorting.desc) && (sorting.column === key))" icon="sort-down" />
                                <font-awesome-icon v-else-if="((!sorting.desc) && (sorting.column === key))" icon="sort-up" />
                            </template>
                        </template>
                    </template>

                    <template v-slot:cell(created_at)="row">
                        {{ date.datetime(row.item.created_at) }}
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
                <br>
                <p> Si no está en la bandeja de entrada, busca en las carpetas. Si un filtro antispam o una regla de correo electrónico movió el correo, es posible que se encuentre en la carpeta Spam, Correo no deseado, Basurero, Elementos eliminados o Archivo </p>
            </b-card-body>
        </b-card>
    </section>
</template>