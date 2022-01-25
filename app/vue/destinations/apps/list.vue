<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Nombre',
                    key: 'name',
                    sortable: true
                },{
                    label: 'Galones',
                    key: 'gallons',
                    sortable: false
                },{
                    label: 'Precio',
                    key: 'price',
                    sortable: true
                },{
                    label: 'Total km',
                    key: 'total_km',
                    sortable: true
                },{
                    label: 'Tipo camión',
                    key: 'truck_type',
                    sortable: true
                },{
                    label: '',
                    key: 'actions'
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 0
                },
                filter: null,
                main_path: '/destinations'
            }
        },
        mounted() {
            this.getData();
            this.$on("clickButtonReload", ()=> {
                this.getData()
            })
        },
        methods: {
            getData(){
                this.http.get(`${this.main_path}.json`).then(response => {
                    this.data = response.data
                    this.pagination.total = this.data.length
                }).catch(error => {
                    console.log(error)
                })
            },
            onFiltered(filteredItems) {
                this.totalRows = filteredItems.length
                this.currentPage = 1
            },
            goTo(event){
                this.$router.push(`/${event.id}`)
            },
            deleteForm(id){
                let url = `${this.main_path}/${id}.json`
                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.data = this.data.filter(e => e.id !== id)
                        this.pagination.total -= 1
                        this.notification('eliminado exitosamente.')
                    } else {
                        this.notification(result.message.error)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },
            notification(text, type = "success"){
                this.$notify({
                    groups: "foo",
                    title: '',
                    type,
                    text
                })
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <component-header-list
            title="Destinos"
            title-button-create="Agregar destino">
        </component-header-list>
        <b-card>
            <b-form-group>
                <b-input-group size="sm">
                    <b-form-input
                        v-model="filter"
                        id="filterInput"
                        placeholder="Buscar ..."
                    ></b-form-input>
                    <b-input-group-append>
                    <b-button :disabled="!filter" @click="filter = ''">x</b-button>
                    </b-input-group-append>
                </b-input-group>
            </b-form-group>
            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="data"
                    :fields="fields"
                    :current-page="pagination.current_page"
                    :per-page="pagination.per_page"
                    :filter="filter"
                    @filtered="onFiltered"
                    @row-clicked="goTo"
                    >
                    <template v-slot:cell(actions)="row">
                        <b-button size="sm" variant="danger" @click.stop="deleteForm(row.item.id)" class="mr-1">
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