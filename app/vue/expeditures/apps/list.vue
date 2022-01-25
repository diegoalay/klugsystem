<script>
import FullCalendar from '@fullcalendar/vue'
import dayGridPlugin from '@fullcalendar/daygrid'
import interactionPlugin from '@fullcalendar/interaction'
import bootstrapPlugin from '@fullcalendar/bootstrap';
import expediture from '../apps/form.vue'

export default {
  components: {
    FullCalendar,
    expediture,
  },
  data() {
    return {
      dateSelected: new Date,
      modal: false,
      expeditures: [],
      calendarExpeditures: [],
      options: {
        units: [],
        types: [],
      },
      calendarPlugins: [
        dayGridPlugin,
        bootstrapPlugin,
        interactionPlugin
      ]
    }
  },
  mounted() {
    this.loadExpeditures();
    this.loadOptions();
  },
  methods: {
    loadExpeditures(){
      const promise = this.http.get('/expeditures.json')
      return promise.then(result => {
          console.log(result.data)
        this.expeditures = result.data.map(item => {
          return this.formatEvent(item);
        });
        this.calendarExpeditures = result.data.map(item => {
          return this.formatEvent(item);
        });
      })
    },
    loadOptions(){
      this.http.get(`/expediture_types.json`).then(response => {
        this.options.types = response.data.map(type => this.formatSelect(type, 'name'));
      });  
      
      this.http.get(`/units.json`).then(response => {
        this.options.units = response.data.map(type => this.formatSelect(type, 'alias'));
      });   
    },
    formatSelect(item, text){
      return {
        value: item.id,
        text: item[text]
      }
    },
    handleClickDate(info) {
      this.dateSelected = info.date;
      this.modal = true
    },
    handleEvent(info) {
      const { object, index } = this.search_array(this.expeditures, parseInt(info.event.id))
      this.dateSelected = new Date(object.date_of)
      this.$refs.formEvent.upload(object)
      this.modal = true
    },
    addEvent(event) {
      console.log(event)
      this.expeditures.push(this.formatEvent(event))
      this.calendarExpeditures.push(this.formatEvent(event))
    },
    updateEvent(event) {
      let { index } = this.search_array(this.expeditures, event.id)
      this.$set(this.expeditures, index, this.formatEvent(event))
      this.$set(this.calendarExpeditures, index, this.formatEvent(event))
    },
    removeEvent(event) {
      this.expeditures = this.expeditures.filter(item => item.id !== event.id)
      this.calendarExpeditures = this.calendarExpeditures.filter(item => item.id !== event.id)
    },
    controlEvent(employee, event_id){
      if (employee.id === this.options.current_employee_id) {
        if (employee.selected) this.options.assigned_events.push(event_id);
        else this.options.assigned_events.splice( this.options.assigned_events.indexOf(event_id), 1 );
      }
    },    
    formatColor(type){
      switch(type) {
        case 'company': 
          return '#EDD774';
        case 'project':
          return '#77B5EE';
        default: 
          return '#9BD882';
      }
    },
    formatEvent(event) {
      return {
        id: event.id,
        title: event.name,
        date: event.date_of,
        color: this.formatColor(event.type) 
      }
    },
    search_array(array, value) {
      for (let i = 0; i < array.length; i++) {
        if (array[i]['id'] === value) {
            return {
              object: array[i],
              index: i
            }
        }
      }
      return
    }
  },
  watch: {
    option_selected() {
      switch(this.option_selected) {
        case '': {
          this.calendarExpeditures = this.expeditures;
          break;
        }
        case 'mine': {
          this.calendarExpeditures = []
          for(let id in this.options.assigned_events){
            let index = this.expeditures.findIndex(e => e.id === this.options.assigned_events[id]);
            if(index > 0) this.calendarExpeditures.push(this.expeditures[index]);
          }
          break;
        }
        default: {
          this.calendarExpeditures = this.expeditures.filter(item => item.type.includes(this.option_selected));    
        }
      }
    }
  },  
}
</script>

<template lang="pug">
  section.component
    .col-2                        
    //-   model-select(:options="options.filter_events" v-model="option_selected")

    div.modal-mask(v-show="modal")
      div.modal-wrapper
        div.modal-container
          expediture(
            ref="formEvent"
            :date="dateSelected"
            :options="options",
            @control-event="controlEvent", 
            @close="modal = false"
            @save="addEvent"
            @update="updateEvent"
            @remove="removeEvent"
          )
    FullCalendar(
      class="demo-app-calendar"
      ref="fullCalendar"
      :plugins="calendarPlugins"
      :events="calendarExpeditures",
      :height="450",
      eventLimit: true
      locale="es"
      :firstDay="1"
      :header="{left: '', center: 'title', right:  'prev,next' }"
      themeSystem='bootstrap'
      @dateClick="handleClickDate"
      @eventClick="handleEvent"
    )
</template>

<style lang='scss'>
@import '~@fullcalendar/core/main.css';
@import '~@fullcalendar/daygrid/main.css';

.demo-app {
  font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
  font-size: 14px;
}
.demo-app-top {
  margin: 0 0 3em;
}
.demo-app-calendar {
  margin: 0 auto;
  max-width: 900px;
}

 .modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, .5);
  display: table;
  transition: opacity .5s ease-in-out;
}

.modal-wrapper {
  display: table-cell;
  vertical-align: middle;
}

@media (max-width: 768px) {
  .modal-container {
    max-width: 100%;
    overflow-y: auto;
    margin: 0px auto;
    padding: 20px 30px;
    background-color: #fff;
    border-radius: 2px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
    transition: all .5s ease-in-out;
  }
}

.modal-container {
  max-width: 900px;
  max-height: 95vh;
  overflow-y: auto;
  margin: 0px auto;
  padding: 20px 30px;
  background-color: #fff;
  border-radius: 2px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, .33);
  transition: all .5s ease-in-out;
}
</style>
