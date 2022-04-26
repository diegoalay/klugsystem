import app from './core/app'

import dashboardRoutes from './dashboard/routes.js';

// CLIENTS
import clientsRoutes from 'vueApp/crm/clients/routes.js';
import contactsRoutes from 'vueApp/crm/contacts/routes.js';
import crmEventsRoutes from 'vueApp/crm/events/routes.js';

// FINANCE
import quotationsRoutes from 'vueApp/finance/quotations/routes.js';
import salesRoutes from 'vueApp/finance/sales/routes.js';
import expedituresRoutes from 'vueApp/finance/expeditures/routes.js';
import cashRegistersRoutes from 'vueApp/finance/cash_registers/routes.js';

// INVENTORY
import productsRoutes from 'vueApp/inventory/products/routes.js';
import brandsRoutes from 'vueApp/inventory/brands/routes.js';
import departmentsRoutes from 'vueApp/inventory/departments/routes.js';
import measurementUnitsRoutes from 'vueApp/inventory/measurement_units/routes.js';

// POS
import posSalesRoutes from 'vueApp/pos/sales/routes.js';
import posExpedituresRoutes from 'vueApp/pos/expeditures/routes.js';
import cashRegisterRoutes from 'vueApp/pos/cash_registers/routes.js';


// HR
import employeeRoutes from 'vueApp/hr/employees/routes.js';

// CONFIGURATIONS
import eventTypesRoutes from 'vueApp/configurations/event_types/routes.js';
import clientTypesRoutes from 'vueApp/configurations/client_types/routes.js';
import expeditureTypesRoutes from 'vueApp/configurations/expediture_types/routes.js';
import productTransactionTypesRoutes from 'vueApp/configurations/product_transaction_types/routes.js';

// ADMINISTRATION
import usersRoutes from 'vueApp/administration/users/routes.js';
import rolesRoutes from 'vueApp/administration/roles/routes.js';
import branchOfficesRoutes from 'vueApp/administration/branch_offices/routes.js';
import paymentMethodsRoutes from 'vueApp/administration/payment_methods/routes.js';
import digifactRoutes from 'vueApp/administration/digifact/routes.js';
import accountRoutes from 'vueApp/administration/account/routes.js';

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
    .concat(cashRegistersRoutes)
    // INVENTORY
    .concat(productsRoutes)
    .concat(brandsRoutes)
    .concat(departmentsRoutes)
    .concat(measurementUnitsRoutes)
    // ADMINISTRATION
    .concat(usersRoutes)
    .concat(rolesRoutes)
    .concat(branchOfficesRoutes)
    .concat(paymentMethodsRoutes)
    .concat(digifactRoutes)
    .concat(accountRoutes)
    // HR
    .concat(employeeRoutes)
    // POS
    .concat(posSalesRoutes)
    .concat(posExpedituresRoutes)
    .concat(cashRegisterRoutes)
    // CONFIGURATIONS
    .concat(clientTypesRoutes)
    .concat(expeditureTypesRoutes)
    .concat(productTransactionTypesRoutes)
    .concat(eventTypesRoutes)
    .concat(booksRoutes)
    // PROFILE
    .concat(profileRoutes)
)