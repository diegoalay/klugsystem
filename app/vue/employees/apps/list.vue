<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Nombre',
                    key: 'first_name',
                    sortable: true
                },{
                    label: 'Apellido',
                    key: 'surname',
                    sortable: true
                },{
                    label: 'DPI',
                    key: 'identity_document_number',
                    sortable: true
                },{
                    label: '',
                    key: 'actions'
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1
                },
                search_text: '',
                main_path: '/employees',
                loading: false
            }
        },
        mounted() {
            this.list()
        },
        methods: {
            list(){
                this.loading = true
                this.http.get(`${this.main_path}.json`).then(response => {
                    this.data = response.data
                    this.pagination.total = this.data.length

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            show(employee){
                this.$router.push(`/${employee.id}`)
            },
            deleteRecord(id){
                let url = `${this.main_path}/${id}.json`
                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.data = this.data.filter(e => e.id !== id)
                        this.pagination.total -= 1
                        // this.notification('eliminado exitosamente.')
                    } else {
                        // this.notification(result.message.error)
                    }
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
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <component-header-list
            title="Empleados"
            title-button-create="Agregar empleado"
            :loading="loading"
            @reloadList="list"
        >
        </component-header-list>

        <b-card>
            <component-search-list :loading="loading" @search="onSearch"/>
            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="data"
                    :fields="fields"
                    :current-page="pagination.current_page"
                    :per-page="pagination.per_page"
                    :filter="search_text"
                    @filtered="onFiltered"
                    @row-clicked="show"
                >
                    <template v-slot:cell(actions)="row">
                        <b-button variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
                            <b-icon icon="trash-fill"></b-icon>
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