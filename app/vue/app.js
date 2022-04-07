import app from './core/app'

import dashboardRoutes from './dashboard/routes.js';

import cashRegisterRoutes from 'vueApp/finance/cash_registers/routes.js';

// CLIENTS
import clientsRoutes from 'vueApp/crm/clients/routes.js';
import contactsRoutes from 'vueApp/crm/contacts/routes.js';
import crmEventsRoutes from 'vueApp/crm/events/routes.js';

// FINANCE
import salesRoutes from 'vueApp/finance/sales/routes.js';
import expedituresRoutes from 'vueApp/finance/expeditures/routes.js';

// INVENTORY
import productsRoutes from 'vueApp/inventory/products/routes.js';
import brandsRoutes from 'vueApp/inventory/brands/routes.js';
import departmentsRoutes from 'vueApp/inventory/departments/routes.js';

import employeeRoutes from './employees/routes.js';

import catalogEventTypesRoutes from './catalog_event_types/routes.js';
import catalogClientTypesRoutes from './catalog_client_types/routes.js';
import catalogExpeditureTypesRoutes from './catalog_expediture_types/routes.js';
import catalogProductTransactionTypesRoutes from './catalog_product_transaction_types/routes.js';

import paymentMethodsRoutes from './payment_methods/routes.js';

// ADMINISTRATION
import branchOfficesRoutes from 'vueApp/administration/branch_offices/routes.js';

import booksRoutes from './books/routes.js'

import profileRoutes from './profile/routes.js'

app("",
    dashboardRoutes
    // CRM
    .concat(clientsRoutes)
    .concat(contactsRoutes)
    .concat(crmEventsRoutes)
    // FINANCE
    .concat(salesRoutes)
    .concat(expedituresRoutes)
    .concat(cashRegisterRoutes)
    // INVENTORY
    .concat(productsRoutes)
    .concat(brandsRoutes)
    .concat(departmentsRoutes)
    // ADMINISTRATION
    .concat(branchOfficesRoutes)
    // TODO
    .concat(employeeRoutes)
    .concat(catalogClientTypesRoutes)
    .concat(catalogExpeditureTypesRoutes)
    .concat(catalogProductTransactionTypesRoutes)
    .concat(catalogEventTypesRoutes)
    .concat(paymentMethodsRoutes)
    .concat(booksRoutes)
    .concat(profileRoutes)
)