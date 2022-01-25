<script>
import VueSelect from 'vue-select'

export default {
  components: {
    VueSelect
  },
  props: {
    date: {
      type: Date,
      required: true
    },
    options: {
      type: Object,
      required: true,
    }
  },
  data() {
    return {
      pagination: { perPage: 5, currentPage: 1 },
      expediture: {
        id: null,
        name: null,
        amount: null,
        expediture_type_id: null,
        companies_id: null,
        unit_id: null,
        date_of: null,
      }
    }
  },
  mounted() {

  },
  methods: {
    upload (expediture) {
      this.$http.get(`/expeditures/${expediture.id}.json`).then(response => {
        this.expediture = response.data;
      });
    },
    cleanEmployees(){
      for (let i = 0, len = this.employees.length; i < len; i++) {
        this.employees[i].selected = false;
      }
    },
    clearData() {
      this.expediture = {
        id: null,
        name: null,
        amount: null,
        expediture_type_id: null,
        companies_id: null,
        unit_id: null,
        date_of: null
      }
    },
    close() {
      this.clearData()
      this.$emit('close')
    },
    remove() {
      if (confirm('¿ Seguro que desea eliminarlo del sisteama ?')) {
        this.$http.delete(`/expeditures/${this.expediture.id}.json`).then(response => {
          if (response.data.successful) {
            alert('Se ha eliminado exitosamente', "success")
            this.$emit('remove', this.expediture)
          } else {
            alert("error")
          }
          this.close()
        })
      }
    },
    async save() {
      if (this.expediture.id) {
        this.$http.put(`/expeditures/${this.expediture.id}.json`, {expediture: this.expediture})
          .then(response => {
            if (response.data.id) {
              this.$emit('update', response.data)
              alert('Se ha actualizado exitosamente')
            } else {
              alert(response.data.errors, "danger")
            }
            this.close()
          })
      } else {
        delete this.expediture.id;
        this.expediture.date_of = this.date;
        this.$http.post("/expeditures/", this.expediture)
          .then(response => {
            if (response.data.successful) {
              this.expediture =  response.data.data
              this.$emit('save', this.expediture)
              alert('Se ha guardado exitosamente.')
            } else {
              alert("error")
            }
            this.close()
          })
      }
    },
    linkTo() {
      if (this.event.type === 'company') this.goTo('companies', 'view', this.event.companies_id);
      else if (this.event.type === 'project') this.goTo('projects', 'view', this.event.project_id);
    }
  },
}
</script>

<style lang="scss">
    .tab-content {
        border: none;
    }

    .without {
        padding: 0 !important;
    }
</style>

<template lang="pug">
    div
        b-form-group(label="Descripcion")
          b-form-input(required type="text" v-model="expediture.name")

        b-form-group(label="Cantidad")
          b-form-input(type="number" v-model="expediture.amount")  
        
        b-form-group(label="Unidad")
          b-form-select(type="text" :options="options.units" v-model="expediture.unit_id")
        
        b-form-group(label="Tipo")
          b-form-select(type="text" :options="options.types" v-model="expediture.expediture_type_id")

        .row
          .col-4.col-xs-4.col-sm-4
            b-button(variant="danger" squared @click="close") {{  "Cancelar" }}
          .col-4.col-xs-4.col-sm-4
            b-button(variant="primary" squared @click="save") {{ "Guardar" }}
          .col-4.col-xs-4.col-sm-4
            b-button(v-if="expediture.id !== null" class="float-right" variant="danger" squared @click="remove") {{  "Eliminar" }}
</template>

<style lang="css">

</style>