import app from './core/app'

import dashboardRoutes from './dashboard/routes.js';

import cashRegisterRoutes from 'vueApp/finance/cash_registers/routes.js';

// CLIENTS
import clientsRoutes from 'vueApp/crm/clients/routes.js';
import contactsRoutes from 'vueApp/crm/contacts/routes.js';
import crmEventsRoutes from 'vueApp/crm/events/routes.js';

// FINANCE
import quotationsRoutes from 'vueApp/finance/quotations/routes.js';
import salesRoutes from 'vueApp/finance/sales/routes.js';
import expedituresRoutes from 'vueApp/finance/expeditures/routes.js';

// INVENTORY
import productsRoutes from 'vueApp/inventory/products/routes.js';
import brandsRoutes from 'vueApp/inventory/brands/routes.js';
import departmentsRoutes from 'vueApp/inventory/departments/routes.js';

import employeeRoutes from 'vueApp/hr/employees/routes.js';

import catalogEventTypesRoutes from './catalog_event_types/routes.js';
import catalogClientTypesRoutes from './catalog_client_types/routes.js';
import catalogExpeditureTypesRoutes from './catalog_expediture_types/routes.js';
import catalogProductTransactionTypesRoutes from './catalog_product_transaction_types/routes.js';

// ADMINISTRATION
import usersRoutes from 'vueApp/administration/users/routes.js';
import rolesRoutes from 'vueApp/administration/roles/routes.js';
import branchOfficesRoutes from 'vueApp/administration/branch_offices/routes.js';
import paymentMethodsRoutes from 'vueApp/administration/payment_methods/routes.js';
import digifactRoutes from 'vueApp/administration/digifact/routes.js';

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
    .concat(quotationsRoutes)
    .concat(cashRegisterRoutes)
    // INVENTORY
    .concat(productsRoutes)
    .concat(brandsRoutes)
    .concat(departmentsRoutes)
    // ADMINISTRATION
    .concat(usersRoutes)
    .concat(rolesRoutes)
    .concat(branchOfficesRoutes)
    .concat(paymentMethodsRoutes)
    .concat(digifactRoutes)
    // TODO
    .concat(employeeRoutes)
    .concat(catalogClientTypesRoutes)
    .concat(catalogExpeditureTypesRoutes)
    .concat(catalogProductTransactionTypesRoutes)
    .concat(catalogEventTypesRoutes)
    .concat(booksRoutes)
    .concat(profileRoutes)
)