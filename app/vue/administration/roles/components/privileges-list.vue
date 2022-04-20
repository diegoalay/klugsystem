<script type="text/javascript">
export default {
    props: {
        roleId: {
            required: true
        }
    },
    data() {
        return {
            role_menu_items: [],
            menu_items: null,
            data: []
        }
    },
    mounted(){
        this.parseData()
    },
    methods: {
        async parseData(){
            this.menu_items = await this.getMenuItems()
            this.role_menu_items = await this.getRoleMenuItems()

            for (let index in this.menu_items) {
                const menu_item = this.menu_items[index]

                const find = this.role_menu_items.find(e =>
                    e.role_id === this.roleId &&
                    e.menu_item_id ===menu_item.id
                )

                let details = {
                    key: menu_item.key,
                    icon: menu_item.icon,
                    order: menu_item.order,
                    status: false
                }

                if (find) {
                    details = {
                        ...details,
                        status: true,
                        role_menu_item_id: find.id
                    }
                }

                this.data.push(details)
            }

            console.log(this.data)
        },
        async getMenuItems(){
            return new Promise(async (resolve, reject) => {
                const url = this.url.admin('menu_items')
                await this.http.get(url).then(result => {
                    resolve(result.successful ? result.data : [])
                }).catch(error => {
                    reject()
                    console.log(error)
                })
            })
        },
        async getRoleMenuItems(){
            return new Promise(async (resolve, reject) => {
                const url = this.url.admin('role/:id/menu_items', {id: this.roleId})
                await this.http.get(url).then(result => {
                    resolve(result.successful ? result.data : [])
                }).catch(error => {
                    reject()
                    console.log(error)
                })
            })
        },
        submitRoleMenuItem(menu_item, role_menu_item_id, status){
            if (role_menu_item_id) {
                this.putForm(menu_item, role_menu_item_id, status)
            } else {
                this.postForm(menu_item)
            }
        },

        postForm(menu_item){
            const url = this.url.admin('role/:id/menu_items', {id: this.roleId})
            const form = {
                role_menu_item: {
                    menu_item_id: menu_item.id,
                }
            }
            this.http.post(url, form).then(result => {
                if (result.successful) {
                    const index = this.data.findIndex(e => e.key === menu_item.key)

                    details = this.data[index]
                    details = {
                        ...details,
                        status: true,
                        role_menu_item_id: result.data.id
                    }

                    this.$set(this.data, index, details)

                    this.$toast.success('Permiso actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(menu_item, role_menu_item_id, status){
            const url = this.url.admin('role/:id/menu_items/:role_menu_item_id',
                {
                    id: this.roleId,
                    role_menu_item_id: role_menu_item_id
                }
            )

            const form = {
                role_menu_item: {
                    status
                }
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    const index = this.data.findIndex(e => e.key === menu_item.key)

                    details = this.data[index]
                    details = {
                        ...details,
                        status: status
                    }

                    this.$set(this.data, index, details)

                    this.$toast.success('Permiso actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
    }
}
</script>

<template>
    <section>
        <b-row>
            <b-col>
                <b-table-simple
                    :bordered="true"
                    :small="true"
                    :fixed="true"
                >
                    <b-thead>
                        <b-tr>
                            <b-th> Permiso </b-th>
                            <b-th class="text-center"> Estado </b-th>
                        </b-tr>
                    </b-thead>
                    <b-tbody>
                        <b-tr
                            v-for="menu_item in data"
                            :key="menu_item.id"
                        >
                            <b-td>
                                {{ menu_item.key }}
                            </b-td>
                            <b-td class="text-center">
                                <b-form-checkbox
                                    readonly
                                    @change="submitRoleMenuItem(menu_item, menu_item.role_menu_item_id, $event)"
                                    v-model="menu_item.status"
                                >
                                </b-form-checkbox>
                            </b-td>
                        </b-tr>
                    </b-tbody>
                </b-table-simple>
            </b-col>
        </b-row>
    </section>
</template>