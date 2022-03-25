

<script>
    import '@fullcalendar/core/vdom' // solves problem with Vite
    import { Calendar } from '@fullcalendar/core'
    import dayGridPlugin from '@fullcalendar/daygrid'
    import timeGridWeek from '@fullcalendar/timegrid';
    import timeGridDay from '@fullcalendar/timegrid';
    import interactionPlugin from '@fullcalendar/interaction'
    import esLocale from '@fullcalendar/core/locales/es';

    import componentForm from '../components/form.vue'

    export default {
        data() {
            return {
                calendar: null,
                event: {
                    id: null,
                    modalTitle: ''
                }
            }
        },
        components: {
            'component-form': componentForm
        },
        mounted(){
            this.initCalendar()
        },
        methods: {
            postForm(){
                this.calendar.batchRendering(() => {
                    this.calendar.addEvent({ title: this.event.title, start: this.getEventDate() });
                });

                this.clearForm()
            },
            initCalendar(){
                let calendarEl = document.getElementById('calendar');
                this.calendar = new Calendar(calendarEl, {
                    height: this.tools.screenHeight() - 200,
                    plugins: [ dayGridPlugin, timeGridWeek, timeGridDay, interactionPlugin ],
                    dateClick: this.onDateSelect,
                    eventClick: this.onEventClick,
                    locales: [ esLocale ],
                    headerToolbar: {
                        start: 'dayGridMonth,timeGridWeek,timeGridDay',
                        center: this.tools.isMobile() ? null : 'title',
                        end: 'prevYear,prev,today,next,nextYear'
                    }
                });
    
                this.calendar.render();
            },
        
            onDateSelect(arg) {
                this.event.event_date = arg.date

                let date = `${arg.date.getDate()}/${arg.date.getMonth()}/${arg.date.getFullYear()}`
                this.event.modalTitle = `Crear Evento - ${date}`
                this.$bvModal.show('modal')
            },
        
            onEventClick(arg) {
                arg.jsEvent.preventDefault()
        
                let class_names = arg.event.classNames
            },

            getEventDate(){
                return this.event.event_date.toISOString().split('T')[0]
            },

            clearForm(){
                this.event = {
                    id: null,
                    modalTitle: ''
                }

                this.$bvModal.hide('modal')
            }
        }
    }
</script>
<template>
    <div>
        <div id='calendar'></div>
        <b-modal id="modal" centered hide-footer hide-backdrop content-class="shadow" :title="event.modalTitle">
            <component-form 
                :clear-form="clearForm"
                :event="event"
            >
            </component-form>
        </b-modal> 
    </div>
</template>

