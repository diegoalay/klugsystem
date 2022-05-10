<script type="text/javascript">
export default {
    props: {
        role: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            menu_items_parsed: [],
            role_menu_items: [],
            menu_items: null,
            data: [],
            checked: true
        }
    },
    mounted(){
        this.parseData()
    },
    methods: {
        async parseData(){
            this.menu_items = await this.getMenuItems()
            this.role_menu_items = await this.getRoleMenuItems()

            this.menu_items_parsed = []
            for (let index in this.menu_items) {
                const menu_item = this.menu_items[index]

                const find = this.role_menu_items.find(e =>
                    e.role_id === this.role.id &&
                    e.menu_item_id === menu_item.id
                )

                let details = {
                    status: false,
                    id: menu_item.id,
                    key: menu_item.key,
                    text: menu_item.text,
                    icon: menu_item.icon,
                    order: menu_item.order,
                    permissions: menu_item.permissions,
                    menu_item_id: menu_item.menu_item_id
                }

                if (find) {
                    details = {
                        ...details,
                        status: find.status,
                        role_menu_item_id: find.id
                    }
                }

                this.menu_items_parsed.push(details)
            }

            const menu_items_level1 = this.menu_items_parsed.filter(e => e.permissions.length === 0)


            for(let key in menu_items_level1){
                let menu_item = menu_items_level1[key]
                const menu_items = this.menu_items_parsed.filter(e => e.menu_item_id === menu_item.id)

                menu_item = {
                    ...menu_item,
                    menu_items: menu_items
                }

                this.data.push(menu_item)
            }
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
                const url = this.url.admin('roles/:id/menu_items', {id: this.role.id})
                await this.http.get(url).then(result => {
                    resolve(result.successful ? result.data : [])
                }).catch(error => {
                    reject()
                    console.log(error)
                })
            })
        },
        submitRoleMenuItem(menu_item, role_menu_item_id, status){
            console.log(menu_item)
            console.log(role_menu_item_id)
            console.log(status)

            if (role_menu_item_id) {
                this.putForm(menu_item, role_menu_item_id, status)
            } else {
                this.postForm(menu_item)
            }
        },

        postForm(menu_item){
            const url = this.url.admin('roles/:id/menu_items', {id: this.role.id})
            const form = {
                role_menu_item: {
                    menu_item_id: menu_item.id,
                }
            }
            this.http.post(url, form).then(result => {
                if (result.successful) {
                    const index = this.menu_items_parsed.findIndex(e => e.key === menu_item.key)

                    let details = this.menu_items_parsed[index]
                    details = {
                        ...details,
                        status: true,
                        role_menu_item_id: result.data.id
                    }

                    this.$set(this.menu_items_parsed, index, details)

                    console.log(this.menu_items_parsed[index].details)

                    this.$toast.success('Permiso actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(menu_item, role_menu_item_id, status){
            const url = this.url.admin('roles/:id/menu_items/:role_menu_item_id',
                {
                    id: this.role.id,
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
                    const index = this.menu_items_parsed.findIndex(e => e.key === menu_item.key)

                    let details = this.menu_items_parsed[index]
                    details = {
                        ...details,
                        status: status
                    }

                    this.$set(this.menu_items_parsed, index, details)

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
                <b-tabs card>
                    <b-tab v-for="appModule in data" :key="appModule.key">
                        <template #title>
                                <span>
                                    <font-awesome-icon :icon="appModule.icon" />
                                </span>
                                {{ appModule.text }}
                        </template>
                        <b-form-group>
                            <template #label>
                                {{ appModule.text }}
                            </template>
                            <b-form-checkbox
                                v-if="tools.roleCanBeEdited(role)"
                                @change="submitRoleMenuItem(
                                    menu_items_parsed.find(e => appModule.key === e.key),
                                    menu_items_parsed.find(e => appModule.key === e.key).role_menu_item_id,
                                    $event
                                )"
                                v-model="menu_items_parsed.find(e => appModule.key === e.key).status"
                            >
                                {{ menu_items_parsed.find(e => appModule.key === e.key).status ? 'Si' : 'No' }}
                            </b-form-checkbox>
                            <b-form-checkbox
                                v-else
                                disabled
                                switch
                                v-model="checked"
                            >
                                {{ 'Si' }}
                            </b-form-checkbox>
                        </b-form-group>

                        <b-table-simple
                            :bordered="true"
                            :small="true"
                            :fixed="true"
                        >
                            <b-thead>
                                <b-tr>
                                    <b-th><h5><b> Permiso </b></h5></b-th>
                                    <b-th class="text-center"><h5><b> Habilitado </b></h5></b-th>
                                </b-tr>
                            </b-thead>
                            <b-tbody>
                                <b-tr
                                    v-for="menu_item in appModule.menu_items"
                                    :key="menu_item.id"
                                >
                                    <b-td>
                                        <p class="text-dark">
                                            <span>
                                                <font-awesome-icon :icon="menu_item.icon" />
                                            </span>
                                            <b> {{ menu_item.text }} </b>
                                        </p>
                                    </b-td>
                                    <b-td class="text-center">
                                        <b-form-checkbox
                                            v-if="tools.roleCanBeEdited(role)"
                                            :disabled="!menu_items_parsed.find(e => appModule.key === e.key).status"
                                            @change="submitRoleMenuItem(
                                                menu_items_parsed.find(e => menu_item.key === e.key),
                                                menu_items_parsed.find(e => menu_item.key === e.key).role_menu_item_id,
                                                $event
                                            )"
                                            v-model="menu_items_parsed[menu_items_parsed.findIndex(e => menu_item.key === e.key)].status"
                                        >
                                            {{ menu_item.status ? 'Si' : 'No' }}
                                        </b-form-checkbox>
                                        <b-form-checkbox
                                            switch
                                            v-else
                                            disabled
                                            v-model="checked"
                                        >
                                            {{ 'Si' }}
                                        </b-form-checkbox>
                                    </b-td>
                                </b-tr>
                            </b-tbody>
                        </b-table-simple>
                    </b-tab>
                </b-tabs>
            </b-col>
        </b-row>
    </section>
</template>