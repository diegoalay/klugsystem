<script type="text/javascript">
    import { Calendar } from '@fullcalendar/core'
    import dayGridPlugin from '@fullcalendar/daygrid'
    import timeGridWeek from '@fullcalendar/timegrid';
    import timeGridDay from '@fullcalendar/timegrid';
    import interactionPlugin from '@fullcalendar/interaction'
    import esLocale from '@fullcalendar/core/locales/es';

    export default {
        components: {

        },
        data() {
            return {
                filters: {
                    data: 'mine'
                },
                summary: {},
                products: [],
                products_total: 0,
                loading: false,
                fields: [{
                    label: 'Imágen',
                    key: 'thumbnail',
                },{
                    label: 'Nombre',
                    key: 'name',
                    sortable: true
                },{
                    label: 'Precio',
                    key: 'retail_price',
                    sortable: true
                },{
                    label: 'Cantidad',
                    key: 'quantity',
                    sortable: true
                },{
                    label: 'Estado',
                    key: 'status',
                    sortable: true
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1,
                    order_by: 'quantity',
                    order: false,
                },
                search_text: '',
                calendar: null
            }
        },
        mounted() {
            this.getSummary()
            this.getProducts()
            this.initCalendar()
        },
        methods: {
            getSummary(){
                this.loading = true

                const url = this.url.build('dashboard')
                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.summary = response.data
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },

            getProducts(){
                this.loading = true
                const url = this.url.inventory('products')
                .filters({search: this.search_text})
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    this.loading = false
                    if (response.successful) {
                        this.products = response.data.products
                        this.pagination.total = response.data.total_count
                    } else {
                        this.$toast.error(result.error.message)
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            onSearch(text){
                this.search_text = text

                this.getProducts()
            },

            initCalendar(){
                let calendarEl = document.getElementById('calendar');
                this.calendar = new Calendar(calendarEl, {
                    height: this.tools.screenHeight() - 300,
                    plugins: [ dayGridPlugin, timeGridWeek, timeGridDay, interactionPlugin ],
                    dateClick: this.onDateSelect,
                    eventClick: this.onEventClick,
                    locales: [ esLocale ],
                    headerToolbar: {
                        start: 'dayGridMonth,timeGridWeek,timeGridDay',
                        center: this.tools.isMobile() ?
                            null :
                            'title',
                        end: this.tools.isMobile() ?
                            'prev,today,next' :
                            'prevYear,prev,today,next,nextYear'
                    }
                });

                this.calendar.render();
            }
        },
        watch: {
            'pagination.current_page'() {
                this.getProducts()
            },

            'pagination.order_by'() {
                this.getProducts()
            },

            'pagination.order'(){
                this.getProducts()
            }
        }
    }
</script>

<template>
    <section>
        <b-row>
            <b-col>
                <b-row>
                    <b-col md="6" sm="12">
                        <b-card  title="Gastos" class="dashboard-top-box">
                            <b-row>
                                <b-col md="4" sm="4" class="text-left">
                                    <h5 class="text-danger">
                                        <font-awesome-icon icon="arrow-down"/> {{ summary.expeditures_count }}
                                    </h5>
                                </b-col>
                                <b-col md="7" sm="7" class="dashboard-value text-right">
                                    <h3> Q. {{ summary.expeditures_total }} </h3>
                                </b-col>
                            </b-row>
                        </b-card>
                    </b-col>
                    <b-col md="6" sm="12">
                        <b-card title="Ventas" class="dashboard-top-box">
                            <b-row>
                                <b-col md="4" sm="4" class="dashboard-counter text-left">
                                    <h5 class="text-success">
                                        <font-awesome-icon icon="arrow-up"/> {{ summary.sales_count }}
                                    </h5>
                                </b-col>
                                <b-col md="8" sm="8" class="dashboard-value text-right">
                                    <h3> Q. {{ summary.sales_total }} </h3>
                                </b-col>
                            </b-row>
                        </b-card>
                    </b-col>
                </b-row>
                <b-row>
                    <b-col md="12" sm="12">
                        <b-card class="dashboard-graph">
                            <div id='calendar'></div>
                        </b-card>
                    </b-col>
                </b-row>
            </b-col>
            <b-col md="4" sm="12">
                <b-card class="dashboard-products">
                    <component-search-list :loading="loading" @search="onSearch"/>
                    <b-table
                        striped
                        hover
                        :items="products"
                        :fields="fields"
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

                        <template v-slot:cell(thumbnail)="row">
                            <b-img :src="tools.getProductImage(row.item)" width="50" rounded alt="image"> </b-img>
                        </template>

                        <template v-slot:cell(status)="row">
                            <div v-if="row.item.quantity <= 0" class="p-1 text-danger">
                                {{ row.item.status }}
                            </div>
                            <div v-else class="p-1 text-success">
                                {{  row.item.status }}
                            </div>
                        </template>

                        <template v-slot:cell(actions)="row">
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
                        >
                        </b-pagination>
                    </b-col>
                </b-card>
            </b-col>
        </b-row>
    </section>
</template>