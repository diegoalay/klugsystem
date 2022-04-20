<script type="text/javascript">
export default {
    props: {
        roleId: {
            required: true,
            type: Number
        }
    },
    data() {
        return {
            data: [],
            fields: [{
                label: 'Fecha de creación',
                key: 'created_at',
                sortable: true
            },{
                label: 'E-Mail',
                key: 'email',
                sortable: true
            },{
                label: 'Nombre',
                key: 'user_name',
                sortable: true
            }],
            pagination: {
                total: 0,
                per_page: 10,
                current_page: 1
            },
            sorting: {
                desc: false,
                column: 'user_name'
            },
            search_text: '',
            loading: false
        }
    },
    mounted() {
        this.list()
    },
    methods: {
        list(){
            this.loading = true
            const url = this.url.admin('roles/:id/users', {id: this.roleId})

            this.http.get(url).then(response => {
                this.data = response.data
                this.pagination.total = this.data.length

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
        }
    },
    watch: {
        roleId(){
            this.list()
        }
    }
}
</script>

<template>
    <section>
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
            </b-card-body>
        </b-card>
    </section>
</template>