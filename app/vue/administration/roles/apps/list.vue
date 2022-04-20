<script type="text/javascript">
import componentUsersList from 'vueApp/administration/roles/components/users-list.vue'
import componentPrivilegesList from 'vueApp/administration/roles/components/privileges-list.vue'

export default {
    components: {
        'component-privileges-list': componentPrivilegesList,
        'component-users-list': componentUsersList
    },
    data() {
        return {
            data: [],
            fields: [{
                label: 'Fecha de creación',
                key: 'created_at',
                sortable: true
            },{
                label: 'Nombre',
                key: 'name',
                sortable: true
            },{
                label: 'Cant. usuarios',
                key: 'users_count',
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
            sorting: {
                desc: false,
                column: 'role_name'
            },
            search_text: '',
            loading: false,
            role: {
                id: null,
                name: null
            }
        }
    },
    mounted() {
        this.list()
    },
    methods: {
        list(){
            this.loading = true
            const url = this.url.admin('roles')

            this.http.get(url).then(response => {
                this.data = response.data
                this.pagination.total = this.data.length

                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },
        show(role){
            this.$router.push(this.url.admin('roles/:id', {id: role.id}).toString(false))
        },
        deleteRecord(id){
            const url = this.url.admin('roles/:id', {id: id})
            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.data = this.data.filter(e => e.id !== id)
                    this.pagination.total -= 1

                    this.$toast.success('rolee eliminado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
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
        },
        showPrivileges(role){
            this.$set(this.role, 'id', role.id)
            this.$set(this.role, 'name', role.name)

            this.$bvModal.show('privileges')
        },
        showUsers(role){
            this.$set(this.role, 'id', role.id)
            this.$set(this.role, 'name', role.name)

            this.$bvModal.show('users')
        }
    }
}
</script>

<template>
    <section>

        <b-modal
            id="privileges"
            size="lg"
            hide-footer
            hide-backdrop
            centered
            content-class="shadow"
            :title="`Permisos asignados a ${role.name}`"
        >
            <component-privileges-list :roleId="role.id"/>
        </b-modal>

        <b-modal
            id="users"
            size="lg"
            hide-footer
            hide-backdrop
            centered
            content-class="shadow"
            :title="`Usuarios asignados a ${role.name}`"
        >
            <component-users-list :roleId="role.id"/>
        </b-modal>

        <component-header-list
            title="Roles"
            title-button-create="Agregar roles"
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

                    <template v-slot:cell(actions)="row">
                        <b-button variant="outline-dark" @click.stop="showPrivileges(row.item)" class="mr-1">
                            <font-awesome-icon icon="pencil" />
                        </b-button>

                        <b-button variant="outline-dark" @click.stop="showUsers(row.item)" class="mr-1">
                            <font-awesome-icon icon="users" />
                        </b-button>

                        <b-button variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
                            <font-awesome-icon icon="trash" />
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