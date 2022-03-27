

<script>
    import '@fullcalendar/core/vdom' // solves problem with Vite
    import { Calendar } from '@fullcalendar/core'
    import dayGridPlugin from '@fullcalendar/daygrid'
    import timeGridWeek from '@fullcalendar/timegrid';
    import timeGridDay from '@fullcalendar/timegrid';
    import interactionPlugin from '@fullcalendar/interaction'
    import esLocale from '@fullcalendar/core/locales/es';

    import componentForm from '../components/form.vue'
    import componentRowList from '../components/row-list.vue'

    export default {
        props: {
            endPoint: {
                type: String,
                default: 'crm/events'
            }
        },

        data() {
            return {
                calendar: null,
                loading: false,
                event: {},
                calendarData: [],
                reload: false
            }
        },
        components: {
            'component-form': componentForm,
            'component-row-list': componentRowList,
        },
        mounted(){
            this.initCalendar()
            this.getEvents()
        },
        methods: {
            getEvents() {
                const url = this.url.build(this.endPoint).paginate(false)
                
                this.http.get(url).then(result => {
                    this.calendarData = result.data
                }).catch(error => {
                    console.log(error)
                })
            },

            submitEvent(type, event){
                if (type === 'post') {
                    this.calendar.batchRendering(() => {
                        let newEvent = this.parseEvent(
                            {
                                ...event,
                                date: event.date ? event.date : null,
                                time_start: event.time_start ? event.time_start : null,
                                time_end: event.time_end ? event.time_start : null
                            }
                        )

                        this.calendar.addEvent(newEvent)
                        this.reloadSimpleList()
                    })
                } else {

                      const index_1 = this.calendarData.findIndex(e => e.id == event.id)

                    if (index_1 !== -1) {
                        this.calendar.batchRendering(() => {
                            if (type === 'put') {
                                this.$set(this.calendarData, index_1, event)
                            } else if (type == 'destroy') {
                                this.calendarData = this.calendarData.filter(e => e.id !== event.id)
                                this.reloadSimpleList()
                            }
                        })
                    }
                }

                this.clearEvent()
            },

            clearEvent(){
                this.event = {
                    id: null,
                    modalTitle: '',
                    model_type: this.event.model_type ? 
                        this.event.model_type : 
                        'Contact'
                }
                
                this.$bvModal.hide('modal')
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
            },


            onDateSelect(arg) {
                arg.jsEvent.preventDefault()

                this.clearEvent()
                this.$set(this.event, 'date', arg.date)
                this.$set(this.event, 'modalTitle', `Crear Evento - ${this.date.date(arg.date)}`)
                this.openModal()
            },


            onEventClick(arg) {
                arg.jsEvent.preventDefault()

                this.clearEvent()
                const event = this.calendarData.find((e) => e.id == arg.event.id)
                
                if (event) {
                    this.event = event
                    this.$set(this.event, 'modalTitle', `Editar Evento - ${this.date.date(event.date)}`)      
                    this.openModal()
                }
            },

            showEvent(event) {
                if (event) {
                    this.event = event
                    this.$set(this.event, 'modalTitle', `Editar Evento - ${this.date.date(event.date)}`)      
                    this.openModal()
                }
            },

            parseEvent(event){
                let eventParsed = {
                    ...event,
                    start: this.date.parse(event.date)
                }

                if (event.time_start) {
                    eventParsed.start = event.time_start
                }

                if (event.time_end) {
                    eventParsed.end = event.time_end
                }

                return eventParsed
            },

            parseTitleDate(date){
                return `${date.getDate()}/${date.getMonth()}/${date.getFullYear()}`
            },

            openModal(){
                this.$bvModal.show('modal')
            },

            reloadSimpleList(){
                this.reload = true

                setTimeout(() => {
                    this.reload = false
                }, 100)
            }
        },

        watch: {
            calendarData() {
                this.calendar.batchRendering(() => {
                    // get rendered events in calendar
                    let events = this.calendar.getEvents()

                    // remove events from calendar
                    events.forEach(event => event.remove() )

                    // reload events
                    this.calendarData.forEach(
                        (event) => {
                            this.calendar.addEvent(this.parseEvent(event))
                        }
                    )
                })
            }
        }
    }
</script>
<template>
    <div>
        <component-header-list
            title="Eventos"
            :buttons="false"
        >
        </component-header-list>

        <b-row>
            <b-col md="4" sm="12">
                <component-row-list @show="showEvent" :reload="reload">
                </component-row-list>
            </b-col>
            <b-col md="8" sm="12">
                <b-card>
                    <div id='calendar'></div>
                </b-card>
            </b-col>
        </b-row>
        
        <b-modal id="modal" centered hide-footer hide-backdrop content-class="shadow" :title="event.modalTitle">
            <component-form 
                :event="event"
                @submit="submitEvent"
            >
            </component-form>
        </b-modal> 
    </div>
</template>

